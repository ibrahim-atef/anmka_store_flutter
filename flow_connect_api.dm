use Anmka-Store-API.postman_collection.json and connect with app 

1- create in core folder network folder : 
have :
 1- api_constants file: have all base url for any end point
 2- api_service file use retrofit package for all service 
 3- api_result file : class have tow option success and error class use json serilizable package 
 4- dio_factory file : class have all data and token from all end point 
 5- dependency_injection file : use get it 
 6- api_error_handel file : fix any error and display error message use api_error_model
 7- api_error_model file : model have response any error use json serilizable package
 ///////////////////////////////////////////////////////////
any end point use step : 
1- add url for api_constants
2- in feature folder create : 
    1- data folder have tow folder : 
        - response model and request model 
        - repo file use api service from api_service and use api_result 
    2- logic use cubit and states use freezed in states 
3- create service in api_service and use models response and request 
4- in repo file use  service in api_service
5- create states use freezed and cubit use repo 
6- add repo and cubit in dependency_injection file 
7 - connect cubit with feature ui 


