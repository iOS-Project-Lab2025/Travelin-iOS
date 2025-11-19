//
//  HTTPStatusCode.swift
//  Traveling
//
//  Created by Rodolfo Gonzalez on 17-11-25.
//

import Foundation

enum HTTPStatusCode: Int {
    case accepted = 202
    case alreadyReported = 208
    case badGetaway = 502
    case badRequest = 400
    case bandWidthLimitExceeded = 509
    case blockedByWindowsParentalControls = 450
    case clientClosedRequest = 499
    case conflict = 409
    case created = 201
    case enhanceYourCalm = 420
    case expectationFailed = 417
    case failedDependency = 424
    case forbidden = 403
    case found = 302
    case getawayTimeout = 504
    case gone = 410
    case httpVersionNotSupported = 505
    case imATeapot = 418
    case imUsed = 226
    case insuficientStorage = 507
    case internalServerError = 500
    case lenghtRequired = 411
    case locked = 423
    case methodNotAllowed = 405
    case movedPermanently = 301
    case multipleChoices = 300
    case multiStatus = 207
    case noContent = 204
    case nonAuthoritativeInformation = 203
    case noResponse = 444
    case notAcceptable = 406
    case notExtended = 510
    case notFound = 404
    case notImplemented = 501
    case notModified = 304
    case oK = 200
    case partialContennt = 206
    case paymentRequired = 402
    case permanentRedirect = 308
    case preconditionFailed = 412
    case preconditionRequired = 428
    case processing = 102
    case proxyAuthenticationRequired = 407
    case requestedRangeNotSatisfiable = 416
    case requestEntityTooLarge = 413
    case requestHeaderFieldsTooLarge = 431
    case requestTimeout = 408
    case requestUrlTooLong = 414
    case resetContent = 205
    case retryWith = 449
    case seeOther = 303
    case serviceUnavailable = 503
    case switchingProtocols = 101
    case switchProxy = 306
    case temporaryRedirect = 307
    case tooManyRequest = 429
    case unauthorized = 401
    case unorderedCollection = 425
    case unprocessableEntity = 422
    case unsuppportedMediaType = 415
    case upgradeRequired = 426
    case useProxy = 305
    case variantAlsoNegotiates = 506
}
