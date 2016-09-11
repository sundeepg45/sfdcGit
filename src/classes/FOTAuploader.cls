public with sharing class FOTAuploader {
 
    public string nameFile{get;set;}
    public Blob contentFile{get;set;}
    public Integer rowCount{get;set;}
    public Integer colCount{get;set;}
    
    Public List<Deal_Risk__c> draupload{get;set;}
    //public Zip_Code_Master__c tempZip;
   
 
// taken from stackoverflow.com/questions/10425925/how-to-parse-a-csv-in-salesforce
    public static List<List<String>> parseCSV(String contents,Boolean skipHeaders) {
        List<List<String>> allFields = new List<List<String>>();
         
        // replace instances where a double quote begins a field containing a comma
        // in this case you get a double quote followed by a doubled double quote
        // do this for beginning and end of a field
        contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        // now replace all remaining double quotes - we do this so that we can reconstruct
        // fields with commas inside assuming they begin and end with a double quote
        contents = contents.replaceAll('""','DBLQT');
        // we are not attempting to handle fields with a newline inside of them
        // so, split on newline to get the spreadsheet rows
        List<String> lines = new List<String>();
        try {
            lines = contents.split('\n');
        } catch (System.ListException e) {
            System.debug('Limits exceeded?' + e.getMessage());
        }
        Integer num = 0;
        for(String line : lines) {
        // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() != 0) {
            //break;
         
            List<String> fields = line.split(',');        
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field : fields) {
                if (field.startsWith('"') && field.endsWith('"')) {
                cleanFields.add(field.replaceAll('DBLQT','"'));
            } else if (field.startsWith('"')) {
                makeCompositeField = true;
                compositeField = field;
            } else if (field.endsWith('"')) {
                compositeField += ',' + field;
                cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                makeCompositeField = false;
            } else if (makeCompositeField) {
                compositeField +=  ',' + field;
            } else {
                cleanFields.add(field.replaceAll('DBLQT','"'));
            }
            }
         
        allFields.add(cleanFields);
        system.debug('Fields display'+allFields);
         }
        }
        if (skipHeaders) allFields.remove(0);
            return allFields;                
        }
  
 
   
    public Pagereference ReadFile()
    {                  
            //create a restore point incase the upload fails it can back out everything.
            Savepoint sp = Database.setSavepoint();
            
        draupload = new List<Deal_Risk__c>();      
        List<List<String>> parsedCSV = new List<List<String>>();
        List<String> zips = new List<String>();
       
        //fill up the parsedCSV table
        rowCount = 0;
        colCount = 0;
        
        try{
        
        if (contentFile != null){
            String fileString = contentFile.toString();
            system.debug('contentFile***'+fileString);
            parsedCSV = parseCSV(fileString, false);
            rowCount = parsedCSV.size();
            for (List<String> row : parsedCSV){
                if (row.size() > colCount){
                    colCount = row.size();
                }
            }
         }
        Deal_Risk__c a = new Deal_Risk__c();
        CSV_Version__c vsettings = CSV_Version__c.getInstance('Template Version');
        CSV_Version__c ctsettings = CSV_Version__c.getInstance('Contract Type');
        system.debug('custom setting:v settings*** '+ vsettings.Row__c +'custom setting:ct settings***'+ parsedCSV[0][9]);
        if(vsettings!=null && vsettings.Row__c!=null && ctsettings!=null && (vsettings.Row__c == parsedCSV[0][9])){        
        if(ctsettings!=null && parsedCSV[Integer.Valueof(ctsettings.Row__c)][Integer.Valueof(ctsettings.Column__c)]!=null){
            a.Contract_Type__c = parsedCSV[Integer.Valueof(ctsettings.Row__c)][Integer.Valueof(ctsettings.Column__c)]; 
        }
        if(parsedCSV[6][5]!=null && parsedCSV[6][5].contains('$')){
            parsedCSV[6][5] = parsedCSV[6][5].replace('"','');
            parsedCSV[6][5] = parsedCSV[6][5].replace(',','');
            parsedCSV[6][5] = parsedCSV[6][5].substring(1, parsedCSV[6][5].length());
        a.List_Price__c = Double.Valueof(parsedCSV[6][5]); 
        }                 
     
        if(parsedCSV[8][5]!=null && parsedCSV[8][5].contains('$')){
            parsedCSV[8][5] = parsedCSV[8][5].replace('"','');
            parsedCSV[8][5] = parsedCSV[8][5].replace(',','');
            parsedCSV[8][5] = parsedCSV[8][5].substring(1, parsedCSV[8][5].length());
        a.Sales_Price__c = Double.Valueof(parsedCSV[8][5]);
        }    
        if(parsedCSV[9][5]!=null && parsedCSV[9][5].contains('$')){
            parsedCSV[9][5] = parsedCSV[9][5].replace('"','');
            parsedCSV[9][5] = parsedCSV[9][5].replace(',','');
            parsedCSV[9][5] = parsedCSV[9][5].substring(1, parsedCSV[9][5].length());
        a.Expences__c = Double.Valueof(parsedCSV[9][5]);
        }       
        if(parsedCSV[3][2]!=null && parsedCSV[3][2].contains('%')){
            //parsedCSV[3][2] = parsedCSV[3][2].replace('"','');
            //parsedCSV[3][2] = parsedCSV[3][2].replace(',','');
            parsedCSV[3][2] = parsedCSV[3][2].substring(0, parsedCSV[3][2].length()-1);
        a.Risk_Contingency__c = Decimal.Valueof(parsedCSV[3][2]);
        }  
        if(parsedCSV[4][2]!=null && parsedCSV[4][2].contains('%')){
            //parsedCSV[3][2] = parsedCSV[3][2].replace('"','');
            //parsedCSV[3][2] = parsedCSV[3][2].replace(',','');
            parsedCSV[4][2] = parsedCSV[4][2].substring(0, parsedCSV[4][2].length()-1);
        a.Project_Management_Time__c = Decimal.Valueof(parsedCSV[4][2]);
        }  
        
       draupload.add(a);
       }
       else{
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please check the template version');
            ApexPages.addMessage(errormsg);
   
       }
        }
        catch (Exception e)
        {
            Database.rollback(sp);
            ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured. Please check the template or try again later');
            ApexPages.addMessage(errormsg);
            system.debug('Error display'+e.getmessage());
        }   
        return null;
    } 
   
    public List<Deal_Risk__c> getuploadedActivations()
    {
        if (draupload!= NULL)
            if (draupload.size() > 0)
                return draupload;
            else
                return null;                   
        else
            return null;
    }           
}