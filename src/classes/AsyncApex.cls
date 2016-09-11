global class AsyncApex {
    // testing code updating to server from aside force.com ide
    @future
    public static void AddUserToGroup(list<ID> Users) {
        try {
            List<CollaborationGroupMember> cgm = new List<CollaborationGroupMember>();
            Id cgID = [Select Id FROM CollaborationGroup Where Name='Test Chatter' LIMIT 1].ID;            
            System.debug('+++Chatter Group+++'+cgID);
            for(ID TEMP: Users){                          
               cgm.add(new CollaborationGroupMember(CollaborationGroupId = cgID, MemberId =TEMP));   
            }
            if(cgm !=null){
               insert cgm;
            }
        }
        catch (QueryException qe) {
            System.debug('QueryException in AsyncApex.AddUserToGroup is :' + qe);  
        } 
        catch (Exception ex) {
            System.debug('Exception in AsyncApex.AddUserToGroup is :' + ex);
        }    
    }
}