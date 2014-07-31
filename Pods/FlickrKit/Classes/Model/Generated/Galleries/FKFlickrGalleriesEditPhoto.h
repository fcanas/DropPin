//
//  FKFlickrGalleriesEditPhoto.h
//  FlickrKit
//
//  Generated by FKAPIBuilder on 12 Jun, 2013 at 17:19.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrAPIMethod.h"

typedef enum {
	FKFlickrGalleriesEditPhotoError_InvalidGalleryID = 1,		 /* That gallery could not be found. */
	FKFlickrGalleriesEditPhotoError_InvalidSignature = 96,		 /* The passed signature was invalid. */
	FKFlickrGalleriesEditPhotoError_MissingSignature = 97,		 /* The call required signing but no signature was sent. */
	FKFlickrGalleriesEditPhotoError_LoginFailedOrInvalidAuthToken = 98,		 /* The login details or auth token passed were invalid. */
	FKFlickrGalleriesEditPhotoError_UserNotLoggedInOrInsufficientPermissions = 99,		 /* The method requires user authentication but the user was not logged in, or the authenticated method call did not have the required permissions. */
	FKFlickrGalleriesEditPhotoError_InvalidAPIKey = 100,		 /* The API key passed was not valid or has expired. */
	FKFlickrGalleriesEditPhotoError_ServiceCurrentlyUnavailable = 105,		 /* The requested service is temporarily unavailable. */
	FKFlickrGalleriesEditPhotoError_FormatXXXNotFound = 111,		 /* The requested response format was not found. */
	FKFlickrGalleriesEditPhotoError_MethodXXXNotFound = 112,		 /* The requested method was not found. */
	FKFlickrGalleriesEditPhotoError_InvalidSOAPEnvelope = 114,		 /* The SOAP envelope send in the request could not be parsed. */
	FKFlickrGalleriesEditPhotoError_InvalidXMLRPCMethodCall = 115,		 /* The XML-RPC request document could not be parsed. */
	FKFlickrGalleriesEditPhotoError_BadURLFound = 116,		 /* One or more arguments contained a URL that has been used for abuse on Flickr. */

} FKFlickrGalleriesEditPhotoError;

/*

Edit the comment for a gallery photo.




*/
@interface FKFlickrGalleriesEditPhoto : NSObject <FKFlickrAPIMethod>

/* The ID of the gallery to add a photo to. Note: this is the compound ID returned in methods like flickr.galleries.getList, and flickr.galleries.getListForPhoto. */
@property (nonatomic, strong) NSString *gallery_id; /* (Required) */

/* The photo ID to add to the gallery. */
@property (nonatomic, strong) NSString *photo_id; /* (Required) */

/* The updated comment the photo. */
@property (nonatomic, strong) NSString *comment; /* (Required) */


@end
