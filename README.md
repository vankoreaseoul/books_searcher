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
