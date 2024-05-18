![logo](https://github.com/hwrlshn/Spotify-iOS-API-Wrapper/assets/44808549/f2d3f6fd-5e29-452d-b283-c635b3b0fe09)

## What is this?
This is a wrapper over Spotify's Web API.

## Prepare for usage
1. Create your app project in dashboard on [Spotify Dev](https://developer.spotify.com/) and get Client ID.
2. In settings of your app set a Redirect URIs.
> Example of Redirect URI: `yourappname://callback/`
3. In Xcode in settings of your project set deep link the same like your Redirect URI.
> Example of Deep Link: `yourappname://`

## Installation
1. Open your project in Xcode.
2. Go to "File" > "Swift Packages" > "Add Package Dependency..."
3. Enter the URL of this repository.
4. Choose the version or branch you'd like to use.
5. Click "Next".
6. Xcode will resolve the package and automatically add it to your project's dependencies.

## Usage
Before the start set AppDelegate as delegate of Spotify API Wrapper and init it.
```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
...
let clientId = "yourclientID"
let redirectUri = "yourredirect://uri/"
SpotifyAPIWrapper.shared.delegate = self
SpotifyAPIWrapper.shared.initWrapper(clientID: clientId, redirectUri: redirectUri)
...
}
```
After that you will be redirected to Spotify site where you need agree that Spotify API Wrapper will be able to manage your account.

<details>
  <summary>How it's looks like</summary>
  
![IMG_8640 copy](https://github.com/hwrlshn/Spotify-iOS-API-Wrapper/assets/44808549/3a53a65c-c4b0-4c82-a99d-b5f9ae910fe3)

</details>

After that you can use Spotify API Wrapper for your app.

## Demo app
In progress. Will be here later.

## In progress
This API calls will be realised later:
```
• Artists
• Audiobooks
• Categories
• Chapters
• Episodes
• Genres
• Markets
• Player
• Playlists
• Search
• Shows
• Tracks
```
