## General Information - Build Tools & Version 

- Xcode Version: 14.2
- Swift Version: 5
- iOS Version: 13.0 and above

## Key Points

1. There are a total of 3 tests for unit testing, which covers major functionality of the code which include Save/Get/Remove.
2. The app was profiled using instrument tool, and any memory leaks that were discovered were fixed.
3. The code is devoid of any external dependencies or third-party frameworks.
5. To support future extension, a generalized/abstracted code has been developed.
6. The application flow is regulated by a UITbabar.

## Additional features

As there was no strict obligation to add more functionality than necessary, a few fundamental functionalities are added to the app to give users a sense of a production-ready application.

1. App supports iPhone versions. 
2. Portrait, Upside Down are supported device orientations. 
3. Until items are added to the app, the label "No Giphy Found" is displayed on the List screen. 
4. The user save the file favorite Giphy in File Manager in Background on press of favorite button and on unlike the button the file is removed from file storage.


## Focus Areas

The main areas focussed were:

1. To make testing, debugging, and code readability simpler, use the MVVM (Model-View-ViewModel) structural design pattern. 
2. Viewmodel dependency injection makes it simple to verify UI logic without having to worry about the UI elements changing in the future in accordance with evolving design specifications. 
2. To support operations like retrieve, save, and deletion, File Storage has been employed as  storage. 
3. User interfaces that are suitable for production have been built using simple UX. 
4. To achieve high code coverage, unit testing was conducted. 
5. Each class and method has accurate documentation.

## Architecture

[Model–view–viewmodel] is John Gossman's Architecture.

All of the UI logic (presentation of the data) is separated from the business logic using MVVM (processing the data). The application's layers communicate transparently with one another: 
- Model: The app's operational data model. 
- View: The graphical components of the user interface. The view controller and the idea of the view are intertwined in iOS. 
- ViewModel: Updates views from model outputs and updates the model from view inputs.

The following processes are carried out when a new feature is implemented: 
First and foremost, the view controller will be invoked, and a reference to the ViewModel will be present in the view. 
2. The View will respond to a user action by calling ViewModel. 
3. ViewModel will ask File Manager for retreiving saved data and also removing from file manager.
4. ViewModel alerts the view through binding when we receive a response. 
5. Data from the View will be updated on the UI.

## Contributors

- [Navjot Singh Cheema](https://www.linkedin.com/in/cheemanavjot)
