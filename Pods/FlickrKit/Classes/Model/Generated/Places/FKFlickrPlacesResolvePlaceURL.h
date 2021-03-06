//
//  FKFlickrPlacesResolvePlaceURL.h
//  FlickrKit
//
//  Generated by FKAPIBuilder.
//  Copyright (c) 2013 DevedUp Ltd. All rights reserved. http://www.devedup.com
//
//  DO NOT MODIFY THIS FILE - IT IS MACHINE GENERATED


#import "FKFlickrAPIMethod.h"

typedef NS_ENUM(NSInteger, FKFlickrPlacesResolvePlaceURLError) {
	FKFlickrPlacesResolvePlaceURLError_PlaceURLRequired = 2,		 /*  */
	FKFlickrPlacesResolvePlaceURLError_PlaceNotFound = 3,		 /*  */
	FKFlickrPlacesResolvePlaceURLError_InvalidAPIKey = 100,		 /* The API key passed was not valid or has expired. */
	FKFlickrPlacesResolvePlaceURLError_ServiceCurrentlyUnavailable = 105,		 /* The requested service is temporarily unavailable. */
	FKFlickrPlacesResolvePlaceURLError_WriteOperationFailed = 106,		 /* The requested operation failed due to a temporary issue. */
	FKFlickrPlacesResolvePlaceURLError_FormatXXXNotFound = 111,		 /* The requested response format was not found. */
	FKFlickrPlacesResolvePlaceURLError_MethodXXXNotFound = 112,		 /* The requested method was not found. */
	FKFlickrPlacesResolvePlaceURLError_InvalidSOAPEnvelope = 114,		 /* The SOAP envelope send in the request could not be parsed. */
	FKFlickrPlacesResolvePlaceURLError_InvalidXMLRPCMethodCall = 115,		 /* The XML-RPC request document could not be parsed. */
	FKFlickrPlacesResolvePlaceURLError_BadURLFound = 116,		 /* One or more arguments contained a URL that has been used for abuse on Flickr. */

};

/*

Find Flickr Places information by Place URL.<br /><br />
This method has been deprecated. It won't be removed but you should use <a href="/services/api/flickr.places.getInfoByUrl.html">flickr.places.getInfoByUrl</a> instead.



Response:

<location place_id="kH8dLOubBZRvX_YZ" woeid="2487956" 
                latitude="37.779" longitude="-122.420"
                place_url="/United+States/California/San+Francisco"
                place_type="locality">
   <locality place_id="kH8dLOubBZRvX_YZ" woeid="2487956"
                 latitude="37.779" longitude="-122.420" 
                 place_url="/United+States/California/San+Francisco">San Francisco</locality>
   <county place_id="hCca8XSYA5nn0X1Sfw" woeid="12587707"
                 latitude="37.759" longitude="-122.435" 
                 place_url="/hCca8XSYA5nn0X1Sfw">San Francisco</county>
   <region place_id="SVrAMtCbAphCLAtP" woeid="2347563" 
                latitude="37.271" longitude="-119.270" 
                place_url="/United+States/California">California</region>
   <country place_id="4KO02SibApitvSBieQ" woeid="23424977"
                  latitude="48.890" longitude="-116.982" 
                  place_url="/United+States">United States</country>
</location>

*/
@interface FKFlickrPlacesResolvePlaceURL : NSObject <FKFlickrAPIMethod>

/* A Flickr Places URL.  
<br /><br />
Flickr Place URLs are of the form /country/region/city */
@property (nonatomic, copy) NSString *url; /* (Required) */


@end
