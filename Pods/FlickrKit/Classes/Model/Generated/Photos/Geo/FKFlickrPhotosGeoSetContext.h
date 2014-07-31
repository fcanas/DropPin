//
//  FKFlickrPhotosGeoSetContext.h
//  FlickrKit
//
//  Generated by FKAPIBuilder on 12 Jun, 2013 at 17:19.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrAPIMethod.h"

typedef enum {
	FKFlickrPhotosGeoSetContextError_PhotoNotFound = 1,		 /* The photo id was either invalid or was for a photo not viewable by the calling user. */
	FKFlickrPhotosGeoSetContextError_NotAValidContext = 2,		 /* The context ID passed to the method is invalid. */
	FKFlickrPhotosGeoSetContextError_InvalidSignature = 96,		 /* The passed signature was invalid. */
	FKFlickrPhotosGeoSetContextError_MissingSignature = 97,		 /* The call required signing but no signature was sent. */
	FKFlickrPhotosGeoSetContextError_LoginFailedOrInvalidAuthToken = 98,		 /* The login details or auth token passed were invalid. */
	FKFlickrPhotosGeoSetContextError_UserNotLoggedInOrInsufficientPermissions = 99,		 /* The method requires user authentication but the user was not logged in, or the authenticated method call did not have the required permissions. */
	FKFlickrPhotosGeoSetContextError_InvalidAPIKey = 100,		 /* The API key passed was not valid or has expired. */
	FKFlickrPhotosGeoSetContextError_ServiceCurrentlyUnavailable = 105,		 /* The requested service is temporarily unavailable. */
	FKFlickrPhotosGeoSetContextError_FormatXXXNotFound = 111,		 /* The requested response format was not found. */
	FKFlickrPhotosGeoSetContextError_MethodXXXNotFound = 112,		 /* The requested method was not found. */
	FKFlickrPhotosGeoSetContextError_InvalidSOAPEnvelope = 114,		 /* The SOAP envelope send in the request could not be parsed. */
	FKFlickrPhotosGeoSetContextError_InvalidXMLRPCMethodCall = 115,		 /* The XML-RPC request document could not be parsed. */
	FKFlickrPhotosGeoSetContextError_BadURLFound = 116,		 /* One or more arguments contained a URL that has been used for abuse on Flickr. */

} FKFlickrPhotosGeoSetContextError;

/*

Indicate the state of a photo's geotagginess beyond latitude and longitude.<br /><br />
Note : photos passed to this method must already be geotagged (using the <q>flickr.photos.geo.setLocation</q> method).




*/
@interface FKFlickrPhotosGeoSetContext : NSObject <FKFlickrAPIMethod>

/* The id of the photo to set context data for. */
@property (nonatomic, strong) NSString *photo_id; /* (Required) */

/* Context is a numeric value representing the photo's geotagginess beyond latitude and longitude. For example, you may wish to indicate that a photo was taken "indoors" or "outdoors". <br /><br />
The current list of context IDs is :<br /><br/>
<ul>
<li><strong>0</strong>, not defined.</li>
<li><strong>1</strong>, indoors.</li>
<li><strong>2</strong>, outdoors.</li>
</ul> */
@property (nonatomic, strong) NSString *context; /* (Required) */


@end
