public with sharing class FileUploader 
{
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    String[] filelines = new String[]{};
    //List<Deal_Risk__c> draupload;
    Public List<Deal_Risk__c> draupload{get;set;}
    
    /***This function reads the CSV file and inserts records into the Account object. ***/
    public Pagereference ReadFile()
    {
        try{
                //Convert the uploaded file which is in BLOB format into a string
                //nameFile =blobToString( contentFile,'ISO-8859-1');
                list<list<string>> parsedCSV = FileUploader.parseCSV(contentFile.toString(),false);
                Deal_Risk__c dra = new Deal_Risk__c();
                Map<String,String> lineMap = new Map<String,String>();
                
                 for(list<string> inputvalues:parsedCSV){
                    if (inputvalues[1]!='' && inputvalues[1]!=null && inputvalues[1].Contains('$')){
                    inputvalues[1] = inputvalues[1].substring(1, inputvalues[1].length());
                    System.Debug(' inputvalues[1]..'+ inputvalues[1]);
                    inputvalues[1] = string.Valueof(inputvalues[1].replace(',',''));                
                 }
                    if (inputvalues[4]!='' && inputvalues[4]!=null && inputvalues[4].Contains('$')){
                    inputvalues[4] = inputvalues[4].substring(1, inputvalues[4].length());
                    System.Debug(' inputvalues[4]..'+ inputvalues[4]);
                    inputvalues[4] = string.Valueof(inputvalues[4].replace(',',''));                
                 }
                    //if (inputvalues[2]!='' && inputvalues[2]!=null && inputvalues[2].Contains('%')){
                    //inputvalues[2] = inputvalues[2].substring(0, inputvalues[2].length()-1);
                    //System.Debug(' inputvalues[2]..'+ inputvalues[2]);
                    //inputvalues[2] = string.Valueof(inputvalues[2].replace(',',''));                
                 //}
                 
                 if(inputvalues[1]!='' && inputvalues[1]!=null && inputvalues[2]!='' && inputvalues[2]!=null){
                   //lineMap.put(inputvalues[1],inputvalues[2]);
                   //System.Debug(' First Loop...'+lineMap);
                   }
                 if(inputvalues[1]!='' && inputvalues[1]!=null && inputvalues[4]!='' && inputvalues[4]!=null){
                       lineMap.put(inputvalues[1],inputvalues[4]);
                       System.Debug(' inputvalues[4]..'+ inputvalues[4]);
                   } 
                                    System.Debug(' lineMap..'+ lineMap);
                    //System.Debug(' inputvalues[1]..'+ inputvalues[1]);
                    //System.Debug(' inputvalues[2]..'+ inputvalues[2]);
                    //System.Debug(' inputvalues[4]..'+ inputvalues[4]);
                    /*
                    dra.Contract_Type__c = inputvalues[0];                   
                    dra.List_Price__c = Double.Valueof(inputvalues[1]);       
                    dra.Sales_Price__c = Double.Valueof(inputvalues[2]);
                    dra.Expences__c = Double.Valueof(inputvalues[3]);
                    dra.Risk_Contingency__c = Decimal.Valueof(inputvalues[4]);
                    dra.Project_Management_Time__c = Decimal.Valueof(inputvalues[5]);
                   */
                 }
                 
              if(lineMap.ContainsKey('Contract Type') && lineMap.get('Contract Type')!='' && lineMap.get('Contract Type')!=null){
                //dra.Contract_Type__c=lineMap.get('Contract Type');
              }
              /*if(lineMap.ContainsKey('Risk Contingency') && lineMap.get('Risk Contingency')!='' && lineMap.get('Risk Contingency')!=null){
                System.Debug(' Risk Contingency**..'+ lineMap.get('Risk Contingency'));
                dra.Risk_Contingency__c=decimal.ValueOf(lineMap.get('Risk Contingency'));
              }
              if(lineMap.ContainsKey('Project Management Time') && lineMap.get('Project Management Time')!='' && lineMap.get('Project Management Time')!=null){
                System.Debug(' Project Management Time**..'+ lineMap.get('Project Management Time'));
                dra.Project_Management_Time__c=decimal.valueof(lineMap.get('Project Management Time'));
              } */
              if(lineMap.ContainsKey('List Price') && lineMap.get('List Price')!=null){
                dra.List_Price__c=double.valueof(lineMap.get('List Price'));
              }
              if(lineMap.ContainsKey('Sales Price') && lineMap.get('Sales Price')!=null){
                dra.Sales_Price__c=Double.ValueOf(lineMap.get('Sales Price'));
              }
              if(lineMap.ContainsKey('Expenses') && lineMap.get('Expenses')!=null){
                dra.Expences__c=double.valueof(lineMap.get('Expenses'));
              }                  
                 draupload.add(dra);
         }

                
             /*   //Now sepatate every row of the excel file
                filelines = nameFile.split('\n');
                
                //Iterate through every line and create a Account record for each row
                draupload = new List<Deal_Risk__c>();
                System.Debug('Content File***'+nameFile);
                for (Integer i=1;i<filelines.size();i++)
                //{
                    String[] inputvalues = new String[]{};
                    inputvalues = filelines[i].split(',');                    
                    
                    Deal_Risk__c dra = new Deal_Risk__c();                  
                    dra.Contract_Type__c = inputvalues[0];                   
                    dra.List_Price__c = Double.Valueof(inputvalues[1].substring(2, inputvalues[1].length()).replace(',','').replace('"',''));       
                    dra.Sales_Price__c = Double.Valueof(inputvalues[2].substring(2, inputvalues[2].length()).replace(',','').replace('"',''));
                    dra.Expences__c = Double.Valueof(inputvalues[3]);
                    dra.Risk_Contingency__c = Decimal.Valueof(inputvalues[4]);
                    dra.Project_Management_Time__c = Decimal.Valueof(inputvalues[5]); 
        
        System.Debug('List Price***'+dra.List_Price__c); 
        */
        
                    //draupload.add(dra);
                //}
        // }
         catch(Exception e){
                 ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured reading the CSV file'+e.getMessage());
                ApexPages.addMessage(errormsg);
         }       
        //Finally, insert the collected records
        try{
            //insert draupload;
        }
        catch (Exception e)
        {
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured inserting the records'+e.getMessage());
            ApexPages.addMessage(errormsg);
        }    
        return null;
    }
   
   /**** This function sends back to the visualforce page the list of account records that were inserted ****/ 
    public List<Deal_Risk__c> getuploadedDRAs()
    {
        if (draupload!= NULL)
            if (draupload.size() > 0)
                return draupload;
            else
                return null;                    
        else
            return null;
    }  
        /**
         This function convers the input CSV file in BLOB format into a string
        @param input    Blob data representing correct string in @inCharset encoding
        @param inCharset    encoding of the Blob data (for example 'ISO 8859-1')
     */
    public static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for(Integer i = 0; i < bytesCount; ++i)
            bytes[i] =  hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }         

public static list<list<String>> parseCSV(String contents,Boolean skipHeaders) {
    list<list<String>> allFields = new List<List<String>>();

    // replace instances where a double quote begins a field containing a comma
    // in this case you get a double quote followed by a doubled double quote
    // do this for beginning and end of a field
    contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
    // now replace all remaining double quotes - we do this so that we can reconstruct
    // fields with commas inside assuming they begin and end with a double quote
    contents = contents.replaceAll('""','DBLQT');
    // we are not attempting to handle fields with a newline inside of them
    // so, split on newline to get the spreadsheet rows
    list<String> lines=new list<string>();
    try {
        lines = contents.split('\n');
    } catch (System.ListException e) {
        System.debug('Limits exceeded?  '+e.getMessage());
    }
    integer num=0;
    for(string line :lines) {
        // check for blank CSV lines (only commas)
        if(line.replaceAll(',','').trim().length()!=0 && line!= ''){ 
            //break;
        list<String> fields=line.split(',');    
        list<String> cleanFields=new list<String>();
        string compositeField;
        boolean makeCompositeField=false;
        for(string field : fields) {
            if(field.startsWith('"') && field.endsWith('"')) {
                cleanFields.add(field.replaceAll('DBLQT','"').removeStart('"').removeEnd('"'));
            } else if(field.startsWith('"')) {
                makeCompositeField = true;
                compositeField = field;
            } else if(field.endsWith('"')) {
                compositeField += ',' + field;
                cleanFields.add(compositeField.replaceAll('DBLQT','"').removeStart('"').removeEnd('"'));
                makeCompositeField = false;
            } else if(makeCompositeField) {
                compositeField +=  ',' + field;
            } else{
                cleanFields.add(field.replaceAll('DBLQT','"').removeStart('"').removeEnd('"'));
            }
            //System.Debug('CCCC '+cleanFields);
        }  
        allFields.add(cleanFields);
        System.Debug('allFields..'+allFields);
      }  
    }
    if(skipHeaders) 
        allFields.remove(0);
    return allFields;       
}//END ParseCSV

}
/*
                                       if (inputvalues[1].Contains('$')){
                        inputvalues[1] = inputvalues[1].substring(1, inputvalues[1].length());
                        inputvalues[1] = string.Valueof(inputvalues[1].replace(',','')); 
                   }
                   if (inputvalues[2].Contains('$')){
                        inputvalues[2] = inputvalues[2].substring(1, inputvalues[2].length());
                        inputvalues[2] = string.Valueof(inputvalues[2].replace(',','')); 
                   }
                   */