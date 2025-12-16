class AllValidation{

  String? formValidation(String? value, String errorMessage){
    if(value?.isEmpty ?? true){
      return errorMessage;
    }
    return null;
  }

}

