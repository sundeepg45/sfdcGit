public class whoEdits{
   public final Map<Id,ApexClass> oldMap = new Map<Id,ApexClass>();
   public final Map<Id,ApexClass> newMap = new Map<Id,ApexClass>();
    
    Public void editedBy(){
      ApexClass oldApexClass;
         Set<Id> classIds = new Set<Id>();
         for(ApexClass newApexClass: newMap.Values()){
             if(newApexClass.LastModifiedDate > oldApexClass.LastModifiedDate){
                 
             }
         }
    }
}