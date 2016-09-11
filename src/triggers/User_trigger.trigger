trigger User_trigger on User (after insert, before insert, after update, before update) {
    Profile p = [Select Id, Name From Profile Where Name = 'Chatter Free User' Limit 1];
    if ( Trigger.isInsert  || Trigger.isUpdate) {    
        if ( Trigger.isAfter){
        List<Id> Userids = New list<Id>();           
            for (user u: Trigger.new ){ 
                if(u.ProfileId == p.id){
                Userids.add(u.id);
                System.debug('User ID added to chatter group'+ Userids);    
                }            
            } 
            asyncApex.AddUserToGroup(Userids);             
        }
    }
}