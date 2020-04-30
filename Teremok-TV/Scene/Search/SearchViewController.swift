//
//  SearchViewController.swift
//  Teremok-TV
//
//  Created by R9G on 12/10/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchDisplayLogic: CommonDisplayLogic {
    func displaySerial(id: Int)
    func displayTags(items: [Search.Tag])
}

class SearchViewController: AbstracViewController, SearchDisplayLogic {
    var activityView: LottieHUD?
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic & SearchDataPassing & CommonRoutingLogic)?

    // MARK: Object lifecycle
    @IBAction func searchClick(_ sender: Any) {
        toSearchText()
    }

    @IBOutlet private var searchFldConstraint: NSLayoutConstraint!
    @IBOutlet private var seartchFld: UITextField!
    @IBOutlet private var collectionView: UICollectionView!

    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = SearchInteractor()
        let presenter = SearchPresenter()
        let router = SearchRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle

    var tags: [Search.Tag] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        interactor?.fetchSearchTags()
    }

    func prepareUI() {
        activityView = LottieHUD()
        collectionView.delegate = self
        seartchFld.textColor = UIColor.View.orange
        searchFldConstraint.isActive = false
        let cells = [SearchCharacterCollectionViewCell.self, LoadingCollectionViewCell.self]
        collectionView.register(cells: cells)
    }

    func toggleSearchBarWidth(on: Bool){
        UIView.animate(withDuration: 0.5) {
            self.searchFldConstraint.isActive = on
            self.view.layoutIfNeeded()
        }
    }

    func displayTags(items: [Search.Tag]){
        tags = items
        collectionView.reloadData()
    }
    
    func displaySerial(id: Int){
        hidePreloader()
        router?.navigateToSerial(id: id)
    }

    @objc func search(term: String){
        let searchText = seartchFld.text ?? ""
        print("searching of \(searchText)")
    }
    func toSearchText(){
        guard let txt = seartchFld.text, !txt.isEmpty else {
            seartchFld.resignFirstResponder()
            return
        }
        view.endEditing(true)
        router?.navigateToRazdel(search: txt)
    }
}

extension SearchViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentString: NSString = textField.text! as NSString
//        let newString: String = currentString.replacingCharacters(in: range, with: string) as String

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(SearchViewController.search), object: nil)
        self.perform(#selector(SearchViewController.search), with: nil, afterDelay: 1.0)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        toggleSearchBarWidth(on: true)
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        toggleSearchBarWidth(on: false)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        toSearchText()
        return true
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count + (self.interactor!.hasMore ? 1 : 0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == tags.count {
            let cell = collectionView.dequeueReusableCell(withCell: LoadingCollectionViewCell.self, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withCell: SearchCharacterCollectionViewCell.self, for: indexPath)
        cell.linktoLoad = tags[indexPath.row].imageLink
        return cell
    }
    
}
extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showPreloader()
       // DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.interactor?.selectTag(idx: indexPath.row)
        //}
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if indexPath.row == tags.count-1 {
            self.interactor?.fetchSearchTags()
        }
    }
}
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 65)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
