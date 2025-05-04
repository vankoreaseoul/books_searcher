# Book Searcher
Book Searcher is an iOS app using a public API called 'itbook' to display information of books in both list and detail view. About the API, you can see from https://api.itbook.store/

## Development Info
* Developer: Heawon Seo
* Development Period: 28 April 2025 – 02 May 2025

## Tech Stack
### Language
![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)
### Framework
![UIKit](https://img.shields.io/badge/UIKit-0C1E2C?style=for-the-badge&logo=swift&logoColor=white)
![Combine](https://img.shields.io/badge/Combine-1C1C1E?style=for-the-badge&logo=apple&logoColor=white)
[![PDFKit](https://img.shields.io/badge/PDFKit-228B22?style=flat&logo=apple&logoColor=white)](https://developer.apple.com/documentation/coreimage)
### Architecture
![MVVM](https://img.shields.io/badge/MVVM-blueviolet?style=for-the-badge)

## UI Overview
![Simulator Screen Recording - iPhone 16 - 2025-05-05 at 01 29 29](https://github.com/user-attachments/assets/95422654-0a4a-4faf-a50b-c67f334b53ab)


## Architecture
```
books_searcher
      ├── Data
      │     ├── Cache
      │     │     ├── CacheManager
      │     │     ├── ImageCacheManager
      │     │     └── PDFCacheManager
      │     ├── Model
      │     │     ├── Entity
      │     │     └── ResponseDTO
      │     └── Network
      |            ├── ApiClient
      │            └── BooksRepository
      ├── Delegate
      │      ├── AppDelegate
      │      └── SceneDelegate
      ├── Usecase
      │      ├── GetBookDetailUsecase
      │      ├── LoadBookImageUsecase
      │      ├── LoadBookPDFUsecase
      │      └── SearchBooksUsecase
      ├── Utils
      │     ├── Constant
      │     ├── DIContainer
      │     └── Extension
      ├── View
      │     ├── Common
      │     │     ├── BookImageView
      │     │     └── SpinnerView
      │     ├── Detail
      │     │     ├── PDF
      │     │     │    ├── PDFSectionView
      │     │     │    └── PDFWrapperView       
      │     │     └── DetailViewController
      │     └── Search
      │            ├── PaginationView
      |            ├── SearchTableViewCell
      │            └── SearchViewController
      ├── ViewModel
      │       ├── Detail
      │       │     └── DetailViewModel
      │       └── Search
      |             ├── SearchTableCellViewModel
      │             └── SearchViewModel  
      ├── ApiError
      ├── Assets
      ├── Info
      └── LaunchScreen
```

## Caching Strategy
To provide a smooth and efficient user experience, this project includes a custom caching system for images and PDF files:

- All caching is implemented using built-in Apple frameworks — no third-party libraries are used.
- Once an image or PDF is downloaded, it’s stored in both memory and disk to avoid downloading it again.
- The disk cache has a maximum size limit. When the limit is exceeded, older files are automatically removed first (using a "least recently used" policy).
- To ensure up-to-date content, each cached file has an expiration time. If the file is too old, it will be downloaded again from the server.
- This system helps reduce unnecessary network traffic while still keeping content fresh when it changes on the server.

## Getting Started
### Requirements 
This project uses the following frameworks, each of which has a minimum required version for iOS and Xcode:

| Framework   | Minimum iOS Version | Minimum Xcode Version | Notes |
|-------------|---------------------|------------------------|-------|
| **UIKit**   | iOS 2.0             | -                      | Core UI framework for all iOS apps |
| **Combine** | iOS 13.0            | Xcode 11               | Declarative framework for async and event-driven code |
| **PDFKit**  | iOS 11.0            | Xcode 9                | Provides PDF viewing and rendering capabilities |

> 📌 **Deployment Target** must be set to at least `iOS 13.0`.


<br>To run this project locally, follow these steps:
1. **Clone the repository**
   ```bash
   git clone https://github.com/vankoreaseoul/books_searcher.git

2. **Open the project in Xcode**
<br>Open books_searcher.xcodeproj or books_searcher.xcworkspace in Xcode.

3. **Build and run the app**
<br>Select a simulator or your device, then press Cmd + R to build and launch the app.
