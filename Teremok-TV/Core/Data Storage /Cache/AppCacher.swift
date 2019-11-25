

class AppCacher {
    static var mappable: MappableCacherType {
        return SqliteCacher.common
    }
    static var expirable: ExpirableCacherType {
        return SqliteCacher.common
    }
}
