//
//  Constants.h
//  Jigsaw2
//
//  Created by Jennifer Duffey on 2/28/14.
//  Copyright (c) 2014 Jennifer Duffey. All rights reserved.
//

// Hockey App ID
#define HOCKEY_APP_ID   @"da08044d7ec14316ec0fb57cb9d938c0"

// Facebook App ID
#define FACEBOOK_APP_ID @"220833084765145"
#define FACEBOOK_GRAPH_URL      @"https://graph.facebook.com/"

// Twitter
#define TWITTER_URL                 @"https://api.twitter.com/1.1/"
#define TWITTER_ACCOUNT_IDENTIFIER      @"twitterAccountIdentifier"

#define kBGQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define IS_4_INCH ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

// notifications
#define APP_HANDLED_URL @"appHandledURL"


#ifdef USE_DEV_WEB_SERVICE
#define PEGGSITE_URL    @"https://dev.peggsite.com/"
#define PEGGSITE_API_URL    @"https://dev.peggsite.com/api/"
#define PEGGSITE_LEGAL_URL  @"https://dev.peggsite.com/legal/"
#define PEGGSITE_ABOUT_URL  @"http://journal.peggsite.com/about.html"
#define PEGGSITE_IMAGE_URL  @"http://s3.amazonaws.com/peggsite_user_content_dev/"
#else
#define PEGGSITE_URL    @"https://peggsite.com/"
#define PEGGSITE_API_URL    @"https://peggsite.com/api/"
#define PEGGSITE_LEGAL_URL  @"https://peggsite.com/legal/"
#define PEGGSITE_ABOUT_URL  @"http://journal.peggsite.com/about.html"
#define PEGGSITE_IMAGE_URL  @"http://s3.amazonaws.com/peggsite_user_content/"
#endif

// email
#define PEGGSITE_HELP_EMAIL @"help@peggsite.com"
#define PEGGSITE_FEEDBACK_EMAIL  @"hey@peggsite.com"


#define KEYCHAIN_IDENTIFIER     @"PeggSiteUserData"
#define HOME_VIEW_STATE         @"homeViewState"

#define YOU_TUBE_URL        @"http://www.youtube.com/embed/"
#define VIMEO_URL           @"http://player.vimeo.com/video/"
#define SOUND_CLOUD_URL     @"https://w.soundcloud.com/player/?url=http://api.soundcloud.com/"

#define randomf(minX, maxX) ((float)(arc4random() % (maxX - minX + 1)) + (float)minX)

#define RADIANS(degrees) ((degrees * (float)M_PI) / 180.0f)

#define DATE_FORMAT_STRING          @"yyyy-MM-dd'T'HH:mm:ssZZZ"
#define DATE_FORMAT_STRING_SANS_ZONE @"yyyy-MM-dd HH:mm:ss"

#define ANIMATION_DURATION          0.4

#define APP_WIDTH                   320
#define APP_HEIGHT                  568
#define NAV_BAR_HEIGHT              54
#define TAB_BAR_HEIGHT              45
#define ACTIVITIES_FOOTER_HEIGHT    62
#define SMALL_ARTICLE_SIZE          185
#define ARTICLE_WIDTH               280
#define ARTICLE_HEIGHT              485
#define MEDIA_WIDTH                 280
#define MEDIA_HEIGHT                380
#define MEDIA_HEIGHT_SMALL          320
#define MEDIA_HEIGHT_LARGE          435
#define ARTICLE_SMALL_HEIGHT        290
#define VIDEO_HEIGHT                240
#define TEXT_HEIGHT                 360
#define ARTICLE_SMALL_Y             50
#define DETAILS_VIEW_HEIGHT         50
#define AVATAR_SIZE                 32
#define SMALL_PADDING               5
#define CAPTION_LINE_SPACING        6
#define PADDING                     10
#define HEADER_PADDING              15
#define CELL_HEADER_PADDING         40
#define CELL_HEADER_HEIGHT          50
#define PADDING_RIGHT               20
#define LABEL_HEIGHT                30
#define LARGE_PADDING               80
#define EDIT_MIN_Y                  -240
#define SMALL_GAP                   2
#define BORDER_PADDING              40
#define CUSTOM_ALERT_WIDTH          240
#define CUSTOM_ALERT_HEIGHT         200
#define FRIEND_SECTION_HEIGHT       40
#define INDICATOR_WIDTH             50
#define INDICATOR_HEIGHT            4
#define INDICATOR_TAB               46
#define ARTICLE_PADDING             10
#define ARTICLE_DETAIL_PADDING      15
#define ARTICLE_SHADOW_OFFSET       28
#define ARTICLE_SHADOW_TOP          204
#define CROP_TITLE_OFFSET           25
#define ARTICLE_OFFSET              20
#define SHADOW_OFFSET               14
#define CROP_OFFSET                 80
#define CAPTION_TEXT_HEIGHT         20
#define SEARCH_OFFSET               -270
#define CAPTION_MAX_LENGTH          72
#define SECTION_HEIGHT              40
#define BOARD_DOT_TOP_PADDING       55
#define BOARD_DOT_LEFT_PADDING      63
#define MINI_BOARD_DOT_PADDING      41
#define SMALL_BOARD_DOT_PADDING     55
#define PIXEL_CONVERSION_MULTIPLIER 75
#define ARTICLE_BUTTON_PADDING      30
#define DELETE_BUTTON_PADDING       35
#define COMMENTS_HEIGHT             310
#define EDIT_BUTTON_WIDTH           90
#define EDIT_BUTTON_HEIGHT          37
#define TEXT_VIEW_TITLE_SIZE        50
#define TEXT_LINE_GAP               3
#define KEYBOARD_WIDTH              320
#define KEYBOARD_HEIGHT             216
#define COMMENT_TEXT_WIDTH          240
#define COMMENT_TEXT_HEIGHT         35
#define SEND_BUTTON_WIDTH           45
#define SHARE_WIDTH                 160
#define SHARE_HEIGHT                188
#define SHARE_OFFSET_TOP            15
#define SHARE_OFFSET_LEFT           6
#define SHARE_BUTTON_HEIGHT         40
#define SHARE_DIVIDER_OFFSET        6
#define SHARE_DIVIDER_WIDTH         132
#define SHARE_IMAGE_SIZE            20
#define BOARD_BOTTOM_OFFSET         30
#define BOARD_PADDING               24
#define BOARD_SHADOW_OFFSET         46
#define COMMENT_OFFSET              180
#define SMALL_PAGE_GAP              232
#define PAGE_GAP                    244
#define PAGE_CONTROL_LEFT           25
#define TITLE_TOP                   12
#define SHADOW_HEIGHT               81
#define SHADOW_WIDTH                1455


#define FOLLOW_BUTTON_CORNER_RADIUS     8
#define BOARD_BACKGROUND_CORNER_RADIUS  5
#define CONTENT_CORNER_RADIUS           5

// identifiers
#define HOME_CELL_IDENTIFIER                @"HomeCellIdentifier"
#define HOME_LOADER_IDENTIFIER              @"HomeLoaderIdentifier"
#define HOME_COLLECTION_LOADER_IDENTIFIER   @"HomeCollectionLoaderIdentifier"
#define FRIEND_CELL_IDENTIFIER              @"FriendCellIdentifier"
#define FRIEND_LIST_CELL_IDENTIFIER         @"FriendListCellIdentifier"
#define ADD_FRIEND_CELL_IDENTIFIER          @"AddFriendCellIdentifier"
#define PEGG_FRIEND_CELL_IDENTIFIER         @"PeggFriendCellIdentifier"
#define SEARCH_USER_CELL_IDENTIFIER         @"SearchUserCellIdentifier"
#define FRIEND_COLLECTION_CELL_IDENTIFIER   @"FriendCollectionCellIdentifier"
#define FOLLOW_CELL_IDENTIFIER              @"FollowCellIdentifier"
#define REQUEST_CELL_IDENTIFIER             @"RequestCellIdentifier"
#define PROFILE_LOADER_IDENTIFIER           @"ProfileLoaderIdentifier"
#define COMMENT_CELL_IDENTIFIER             @"CommentCellIdentifier"
#define MENU_CELL_IDENTIFIER                @"MenuCellIdentifier"
#define ACTIVITY_CELL_IDENTIFIER            @"ActivityCellIdentifier"
#define ACTIVITY_LOADER_IDENTIFIER          @"ActivityLoaderIdentifier"
#define PHOTO_CELL_IDENTIFIER               @"PhotoCellIdentifier"


// controllers
#define JOIN_VIEW_CONTROLLER            @"JoinViewController"
#define INTRO_VIEW_CONTROLLER           @"IntroViewController"
#define LOGIN_VIEW_CONTROLLER           @"LoginViewController"
#define HOME_VIEW_CONTROLLER            @"HomeViewController"
#define BOARD_VIEW_CONTROLLER           @"BoardViewController"
#define FULL_SCREEN_VIEW_CONTROLLER     @"FullScreenViewController"
#define FRIENDS_VIEW_CONTROLLER         @"FriendsViewController"
#define FRIEND_LIST_VIEW_CONTROLLER     @"FriendListViewController"
#define FRIEND_VIEW_CONTROLLER          @"FriendViewController"
#define LOVE_VIEW_CONTROLLER            @"LoveViewController"
#define SETTINGS_VIEW_CONTROLLER        @"SettingsViewController"
#define CREATE_VIEW_CONTROLLER          @"CreateViewController"
#define FORGOT_PASSWORD_VIEW_CONTROLLER @"ForgotPasswordViewController"
#define EDIT_VIEW_CONTROLLER            @"EditViewController"
#define ADD_FRIEND_VIEW_CONTROLLER      @"AddFriendViewController"
#define PROFILE_VIEW_CONTROLLER         @"ProfileViewController"
#define COMMENT_VIEW_CONTROLLER         @"CommentViewController"
#define MORE_VIEW_CONTROLLER            @"MoreViewController"
#define LAYOUT_VIEW_CONTROLLER          @"LayoutViewController"
#define ACTIVITY_VIEW_CONTROLLER        @"ActivityViewController"
#define FACEBOOK_FRIEND_VIEW_CONTROLLER @"FacebookFriendViewController"
#define CONTACTS_VIEW_CONTROLLER @"ContactsViewController"
#define TWITTER_VIEW_CONTROLLER @"TwitterViewController"
#define SEARCH_VIEW_CONTROLLER  @"SearchViewController"

#define EDIT_PROFILE_VIEW_CONTROLLER        @"EditProfileViewController"
#define FIND_FRIENDS_VIEW_CONTROLLER        @"FindFriendsViewController"
#define PASSWORD_VIEW_CONTROLLER            @"PasswordViewController"
#define PRIVACY_VIEW_CONTROLLER             @"PrivacyViewController"
#define TERMS_VIEW_CONTROLLER               @"TermsViewController"
#define ABOUT_VIEW_CONTROLLER               @"AboutViewController"
#define PUSH_NOTIFICATIONS_VIEW_CONTROLLER  @"PushNotificationsViewController"
#define SHARE_SETTINGS_VIEW_CONTROLLER      @"ShareSettingsViewController"
#define ARTICLE_VIEW_CONTROLLER             @"ArticleViewController"
#define ADD_VIEW_CONTROLLER                 @"AddViewController"
#define ADD_PHOTO_VIEW_CONTROLLER           @"AddPhotoViewController"

// fonts
#define FONT_PROXIMA_SEMIBOLD           @"ProximaNova-Semibold"
#define FONT_PROXIMA_REGULAR            @"ProximaNova-Regular"
#define FONT_PROXIMA_BOLD               @"ProximaNova-Bold"
#define FONT_PROXIMA_EXTRA_BOLD         @"ProximaNova-Extrabld"
#define FONT_PROXIMA_SEMIBOLD_ITALIC    @"ProximaNova-SemiboldIt"

#define FONT_SIZE_BODY              18
#define FONT_SIZE_TEXT_BOX          13
#define FONT_SIZE_LOVE              14
#define FONT_SIZE_HEADER            19
#define FONT_SIZE_ACTIVITY          14
#define FONT_SIZE_CAPTION           15
#define FONT_SIZE_TIME              12
#define FONT_SIZE_NOTES             15
#define FONT_SIZE_SUBHEADER         12
#define FONT_SIZE_LOGIN_HEADER      17
#define FONT_SIZE_CREATE_HEADER     19
#define FONT_SIZE_MENU_HEADER       17
#define FONT_SIZE_EDIT_BUTTON       14
#define FONT_SIZE_CROP_TEXT         18
#define FONT_SIZE_TEXT_CONTENT      15

#define FONT_TAG_PROXIMA            3
#define FONT_TAG_PROXIMA_SEMIBOLD   4
#define FONT_TAG_PROXIMA_BOLD       5
#define FONT_TAG_PROXIMA_EXTRABOLD  6

#define TOTAL_REGIONS               9
#define TOTAL_ARTICLE_DOTS          9

#define TOTAL_ANIMATED_IMAGES       12

#define ALERT_TAG_DELETE            100
#define ALERT_TAG_ADD_VIDEO         101
#define ALERT_TAG_ADD_AUDIO         102

#define FRIEND_ACTION_SHEET_TAG     105

// images
#define IMAGE_BACK_ICON         @"back"
#define IMAGE_SHORT_BACK_ICON   @"short_back_arrow"
#define IMAGE_FORWARD_ICON      @"forward"
#define IMAGE_ADD_FRIEND_ICON   @"friend_add"
#define IMAGE_PANEL_ICON        @"panel_button"
#define IMAGE_HEART_ICON        @"love"
#define IMAGE_SETTINGS_ICON     @"settings"
#define IMAGE_LOGOUT            @"logout"
#define IMAGE_NOTES             @"notes_icon"
#define IMAGE_LOVE_ACTIVE       @"love_icon_active"
#define IMAGE_COMMENT           @"comment_icon"
#define IMAGE_GENERIC_AVATAR    @"generic_avatar"
#define IMAGE_INFO_ICON         @"more_button"
#define IMAGE_NEW_POST          @"new_post"
#define IMAGE_EDIT_ICON         @"edit_icon"
#define IMAGE_DONE_ICON         @"done_button"
#define IMAGE_DELETE_ICON       @"delete_icon"
#define IMAGE_ACTIVITY_ICON     @"activity_icon"
#define IMAGE_SHARE_BACKGROUND  @"share_background"
#define IMAGE_SHARE_FACEBOOK    @"facebook_icon_small"
#define IMAGE_SHARE_TWITTER     @"twitter_icon"
#define IMAGE_SHARE_EMAIL       @"email_icon"
#define IMAGE_SHARE_URL         @"url_icon"

#define IMAGE_GALLERY_IMAGE_BACKGROUND      @"gallery_add_image"
#define IMAGE_GALLERY_ADD                   @"add"
#define IMAGE_EDIT                          @"edit"
#define IMAGE_DELETE                        @"delete"
#define IMAGE_BOX_SHADOW                    @"box_shadow"
#define IMAGE_SHADOW_BOTTOM                 @"shadow_bottom"
#define IMAGE_PLAY_VIDEO                    @"play_video"
#define IMAGE_PLAY_AUDIO                    @"play_audio"
#define IMAGE_SHOW_DETAIL                   @"detail_arrow"
#define IMAGE_PROFILE_VIEW                  @"profile_view"
#define IMAGE_EDIT_PROFILE                  @"edit_profile"
#define IMAGE_ADD_FRIEND                    @"add_friend"
#define IMAGE_PROFILE_ADD                   @"profile_add"
#define IMAGE_PRIVATE_ON                    @"private_on"
#define IMAGE_PRIVATE_OFF                   @"private_off"
#define IMAGE_DETAIL_ARROW                  @"detail_arrow"
#define IMAGE_REFRESH                       @"refresh_icon"
#define IMAGE_DEFAULT_THUMB                 @"default_post_thumb"
#define IMAGE_BOARD_SHADOW                  @"board_shadow"
#define IMAGE_BROWN_LOADER                  @"brown_loader"
#define IMAGE_GRAY_LOADER                   @"gray_loader"
#define IMAGE_P_LOADER                      @"p_loader"

// colors
#define COLOR_ORANGE_BUTTON                 @"0xf16521"
#define COLOR_CAPTION_TEXT                  @"0x444444"
#define COLOR_MORE_TEXT                     @"0xcccccc"
#define COLOR_TIME_TEXT                     @"0xc3aa90"
#define COLOR_NOTIFICATION_BACKGROUND       @"0x86c928"
#define COLOR_NOTIFICATION_BORDER           @"0x6f3d1d"
#define COLOR_DOT_ACTIVE                    @"0xf16521"
#define COLOR_DOT_INACTIVE                  @"0x8c5f32"
#define COLOR_DOT_SELECTED                  @"0x5f3817"
#define COLOR_ADD_IMAGE_BACKGROUND          @"0xf0ce9c"
#define COLOR_GREEN_BUTTON                  @"0x8ac836"
#define COLOR_GREEN_BUTTON_BORDER           @"0x70a035"
#define COLOR_FOLLOW_BUTTON_TEXT_ACTIVE     @"0x444444"
#define COLOR_FOLLOW_BUTTON_BORDER          @"0x888888"
#define COLOR_FOLLOW_BUTTON_TEXT_INACTIVE   @"0xaaaaaa"
#define COLOR_FOLLOW_BUTTON_INACTIVE        @"0xcccccc"
#define COLOR_BROWN_BUTTON                  @"0x5f3817"
#define COLOR_BROWN_BUTTON_BORDER           @"0xa2856d"
#define COLOR_ARTICLE_BACKGROUND            @"0xeecb9d"
#define COLOR_PAPER                         @"0xf9f8f4"
#define COLOR_COUNT_TEXT                    @"0x8dc63f"
#define COLOR_ARTICLE_TEXT                  @"0x5f3817"
#define COLOR_PROGRESS_ALERT                @"0x9f8465"
#define COLOR_PROGRESS_ALERT_BORDER         @"0xc7ae91"
#define COLOR_ARTICLE_BUTTON                @"0x7a5c3c"
#define COLOR_ARTICLE_STROKE                @"0xa3764a"
#define COLOR_ARTICLE_DIVIDER               @"0xDFD7D1"
#define COLOR_CANCEL_TEXT                   @"0x1f6299"
#define COLOR_SAVE_TEXT                     @"0x70a035"
#define COLOR_BUTTON_TEXT                   @"0x444444"
#define COLOR_EMPTY_BACKGROUND              @"0xfef4e6"
#define COLOR_TEXT_BACKGROUND               @"0xdddddd"
#define COLOR_ADD_BUTTON                    @"0x444444"
#define COLOR_ADD_BUTTON_SELECTED           @"0x8ac836"
#define COLOR_ADD_BUTTON_BORDER_SELECTED    @"0x70a035"
#define COLOR_CONTENT_STROKE                @"0x5f3817"
#define COLOR_CANCEL_BUTTON                 @"0xaaaaaa"
#define COLOR_CONTENT_BACKGROUND            @"0xfefaf4"
#define COLOR_HIGHLIGHT_BORDER              @"0x8ac836"
#define COLOR_INPUT_TEXT                    @"0x444444"
#define COLOR_GRADIENT_ONE                  @"0xfbd495"
#define COLOR_GRADIENT_TWO                  @"0xdea355"
#define COLOR_PLACEHOLDER_TEXT              @"0xcccccc"
#define COLOR_AVATAR_BORDER                 @"0x5f3817"
#define COLOR_SHARE_TEXT                    @"0x666666"
#define COLOR_SHARE_DIVIDER                 @"0xc3aa90"
#define COLOR_SCROLL_BED                    @"0x8c5f32"
#define COLOR_TEXT_CONTENT                  @"0x111111"
#define COLOR_TEXT_LINK                     @"0x3c6789"

#define COLOR_LOGIN_BUTTON      @"0xf16521"
#define COLOR_BEIGE_BUTTON      @"0xfdf0db"
#define COLOR_FORGOT_PASSWORD_BUTTON  @"0xf9efe0"

// text
#define TEXT_MORE               @"MORE OPTIONS"
#define TEXT_EDIT_PROFILE       @"EDIT PROFILE"
#define TEXT_PASSWORD           @"PASSWORD"
#define TEXT_FIND_FRIENDS       @"FIND FRIENDS"
#define TEXT_PUSH               @"NOTIFICATIONS"
#define TEXT_SHARE              @"SHARE SETTINGS"
#define TEXT_ADD_FRIEND         @"ADD FRIEND"
#define TEXT_CONTACTS           @"CONTACTS"
#define TEXT_TWITTER_FRIENDS    @"TWITTER FRIENDS"
#define TEXT_CREATE_ARTICLE     @"create article"
#define TEXT_ARTICLES           @"articles"
#define TEXT_FRIENDS            @"friends"
#define TEXT_FACEBOOK_FRIENDS   @"FACEBOOK FRIENDS"
#define TEXT_LOG_IN             @"Log In To PeggSite"
#define TEXT_JOIN               @"Create Your Profile"
#define TEXT_FORGOT_PASSWORD    @"Forgot Password"
#define TEXT_FOLLOW             @"follow"
#define TEXT_FOLLOWING          @"following"
#define TEXT_PROFILE            @"PROFILE"
#define TEXT_ABOUT              @"ABOUT"
#define TEXT_COMMENTS           @"comments"
#define TEXT_HELP               @"HELP"
#define TEXT_PRIVACY            @"PRIVACY"
#define TEXT_TERMS              @"TERMS"
#define TEXT_EDIT               @"edit"
#define TEXT_ACTIVITY           @"ACTIVITY"
#define TEXT_HEADER_COMMENTS    @" COMMENTS "
#define TEXT_HEADER_LOVES       @" LOVES "
#define TEXT_VIEW_ALL           @"VIEW ALL →"
#define TEXT_CANCEL             @"Cancel"
#define TEXT_SAVE               @"Save"
#define TEXT_DONE               @"DONE"
#define TEXT_ARTICLE            @"ARTICLE"
#define TEXT_SCALE_EDIT         @"SCALE & CROP"

#define TEXT_MAX_LENGTH         150

// protocols
#define HTTP_POST               @"POST"
#define HTTP_GET                @"GET"
#define HTTP_DELETE             @"DELETE"
#define HTTP_PATCH              @"PATCH"
#define HTTP_PUT                @"PUT"

#define HTTP_CODE_SUCCESS       200

#define DEFAULT_LIMIT           25

// keys
#define COOKIE_HEADER               @"authKey"
#define KEY_USERNAME                @"username"
#define KEY_PASSWORD                @"password"
#define KEY_EMAIL                   @"email"
#define KEY_FIRST_NAME              @"first_name"
#define KEY_LAST_NAME               @"last_name"
#define KEY_SHORT_BIO               @"short_bio"
#define KEY_LOCATION                @"location"
#define KEY_LAYOUT_ID               @"layout_id"
#define KEY_DATE_VISITED            @"date_visited"
#define KEY_IS_FAVORITE             @"is_favorite"
#define KEY_PLATFORM                @"platform"
#define KEY_IS_NOTIFY_COMMENT       @"is_notify_comment"
#define KEY_IS_NOTIFY_LOVE          @"is_notify_love"
#define KEY_IS_NOTIFY_FOLLOW        @"is_notify_follow"
#define KEY_IS_PRIVATE              @"is_private"
#define KEY_LOVE                    @"love"
#define KEY_COMMENT                 @"comment"
#define KEY_TYPE                    @"type"
#define KEY_TOKEN                   @"token"
#define KEY_DATE_VIEWED_ACTIVITY    @"date_viewed_activity"

#define KEY_FOLLOWERS           @"followers"
#define KEY_FOLLOWING           @"following"

#define KEY_EXTERNAL_MEDIA_ID   @"external_media_id"
#define KEY_ARTICLE_TYPE_ID     @"article_type_id"
#define KEY_REGION_NUMBER       @"region_num"
#define KEY_TEXT                @"text"
#define KEY_CAPTION             @"caption"
#define KEY_SOURCE              @"src"
#define KEY_LOGIN_USERNAME      @"UserName"
#define KEY_LOGIN_PASSWORD      @"Password"

#define APP_USERS               @"Friends using PeggSite"
#define NON_APP_USERS           @"Friends not using PeggSite"

#define TIMEOUT_INTERVAL          30

#define SCROLL_PAGE_COUNT               5

#define INDEX_SELECTED_FOLLOWERS        100
#define INDEX_SELECTED_FOLLOWING        101
#define INDEX_SELECTED_REQUESTS         102

#define INDEX_SELECTED_ACCEPT           110
#define INDEX_SELECTED_DECLINE          111

#define LOADING_CELL_TAG                112

#define HTTP_RESPONSE_ERROR_DOMAIN  @"HTTPResponseErrorDomain"

// NSNotification names (not sure why I can't just user #define for these)
static NSString * const NotificationUserDidLogin               = @"UserDidLogin";
static NSString * const NotificationUserDidFetch               = @"UserDidFetch";
static NSString * const NotificationUserFriendsDidChange       = @"UserFriendsDidChange";
static NSString * const NotificationUserRequestsDidChange      = @"UserRequestsDidChange";
static NSString * const NotificationUserActivityDidChange      = @"UserActivityDidChange";
static NSString * const NotificationUserFollowersDidChange     = @"FollowersDidChange ";
static NSString * const NotificationUserDidAddFriend           = @"UserDidAddFriend";
static NSString * const NotificationUserDidRemoveFriend        = @"UserDidRemoveFriend";
static NSString * const NotificationDataManagerDidError        = @"DataManagerDidError";

typedef NS_ENUM(NSInteger, IntroButton)
{
    IntroButtonEmail = -1,
    IntroButtonFacebook = 0
};

typedef NS_ENUM(NSInteger, NavState)
{
    NavStateNone = -1,
    NavStateIntro = 0,
    NavStateLogin = 1,
    NavStateJoin = 2,
    NavStateHome = 3,
    NavStateBoard = 4,
    NavStateActivity = 5,
    NavStateProfile = 6,
    NavStateMore = 7,
    NavStateArticleEdit = 8,
    NavStateCreate = 9,
    NavStateEdit = 11,
    NavStateAddFriend = 12,
    NavStateForgotPassword = 13,
    NavStateFullScreen = 14,
    NavStateEditProfile = 19,
    NavStatePassword = 20,
    NavStateFindFriends = 21,
    NavStatePushNotifications = 22,
    NavStateShareSettings = 23,
    NavStateHelp = 24,
    NavStateFeedback = 25,
    NavStateLegal = 26,
    NavStateAbout = 27
};

typedef NS_ENUM(NSInteger, NavButtonState)
{
    NavButtonStateNone = -1,
    NavButtonStateBack = 0,
    NavButtonStateForward = 1,
    NavButtonStatePanel = 2,
    NavButtonStateHeart = 3,
    NavButtonStateSettings = 4,
    NavButtonStateInfo = 5,
    NavButtonStateAddFriend = 6,
    NavButtonStateLogout = 7,
    NavButtonStateShowDetail = 8,
    NavButtonStateCancel = 9,
    NavButtonStateSave = 10,
    NavButtonStateRefresh = 11,
    NavButtonStateEdit = 12,
    NavButtonStateDone = 13,
    NavButtonStateShortBack = 14
};

typedef NS_ENUM(NSInteger, TabButtonState)
{
    TabButtonStateNone = -1,
    TabButtonStateHome = 0,
    TabButtonStateProfile = 1,
    TabButtonStateAdd = 2,
    TabButtonStateActivity = 3,
    TabButtonStateMore = 4
};

typedef NS_ENUM(NSInteger, ArticleType)
{
    ArticleTypeUnknown = 0,
    ArticleTypeImage = 1,
    ArticleTypeYouTube = 2,
    ArticleTypeVimeo = 3,
    ArticleTypeSound = 4,
    ArticleTypeText = 5
};

typedef NS_ENUM(NSInteger, AddContentType)
{
    AddContentTypeText = 100,
    AddContentTypeVideo = 101,
    AddContentTypeAudio = 102,
    AddContentTypePhoto = 103
};

typedef NS_ENUM(NSInteger, PhotoScreen)
{
    PhotoScreenNone = 0,
    PhotoScreenCamera = 201,
    PhotoScreenLibrary = 202,
    PhotoScreenCaption = 203,
    PhotoScreenOverlay = 204
};

typedef NS_ENUM(NSInteger, ActivityType)
{
    ActivityTypeLove = 0,
    ActivityTypeComment = 1,
    ActivityTypeFollow = 2,
    ActivityTypeMention = 3
};

typedef NS_ENUM(NSInteger, RequestType)
{
    RequestTypeLogin = 0,
    RequestTypeLogout = 1,
    RequestTypeSetToken = 2,
    RequestTypeDeleteToken = 3,
    RequestTypeGetUser = 4,
    RequestTypeUpdatePassword = 5,
    RequestTypeRequestPassword = 6,
    RequestTypeCreateUser = 7,
    RequestTypeUpdateUser = 8,
    RequestTypeGetUserActivity = 9,
    RequestTypeGetRequests = 10,
    RequestTypeFavoritedFriend = 11,
    RequestTypeVisitedFriend = 12,
    RequestTypeGetFriends = 13,
    RequestTypeGetFollowers = 14,
    RequestTypeAddFriend = 15,
    RequestTypeRemoveFriend = 16,
    RequestTypeRequestAcceptFriend = 17,
    RequestTypeRequestDeclineFriend = 18,
    RequestTypeGetArticle = 19,
    RequestTypeUpdateArticle = 20,
    RequestTypeDeleteArticle = 21,
    RequestTypeCreateArticle = 22,
    RequestTypeGetLayouts = 23,
    RequestTypePostLove = 24,
    RequestTypeDeleteLove = 25,
    RequestTypePostComment = 26,
    RequestTypeGetActivity = 27,
    RequestTypeUpload = 28,
    RequestTypeUpdateActivity = 29,
    RequestTypeSearchUsers = 30
};

typedef NS_ENUM(NSInteger, ButtonStyle)
{
    ButtonStyleNone = 0,
    ButtonStyleGreen = 1,
    ButtonStyleLogin = 2,
    ButtonStyleForgotPassword = 3,
    ButtonStyleArticle = 4,
    ButtonStyleBrown = 5,
    ButtonStyleBeige = 6,
    ButtonStyleOrange = 7,
    ButtonStyleEdit = 8,
    ButtonStyleAdd = 9,
    ButtonStyleCancel = 10
};

typedef NS_ENUM(NSInteger, SpinnerType)
{
    SpinnerTypeNone = 0,
    SpinnerTypeP = 1,
    SpinnerTypeBrown = 2,
    SpinnerTypeGray = 3
};

typedef NS_ENUM(NSInteger, PostType)
{
    PostTypeSmall = 0,
    PostTypeLarge = 1
};

typedef NS_ENUM(NSInteger, RequestQueueMode)
{
    RequestQueueModeFirstInFirstOut = 0,
    RequestQueueModeLastInFirstOut = 1
};