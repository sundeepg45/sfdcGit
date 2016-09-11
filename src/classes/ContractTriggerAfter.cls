public with sharing class ContractTriggerAfter {

    public final Map<Id,Contract> oldMap = new Map<Id,Contract>();
    public final Map<Id,Contract> newMap = new Map<Id,Contract>();
    
      public static EmailTemplate BID_DESK_NOTIFICATION_EMAIL_TEMPLATE {
    get {
      if(BID_DESK_NOTIFICATION_EMAIL_TEMPLATE == null) {
        for(EmailTemplate et : [
          select Id, Name, Body, HtmlValue, Subject, Description
          from EmailTemplate
          where
            Folder.Type = 'Email'
            and Folder.Name = 'Contract related' 
            and DeveloperName = 'BidDeskNotificationsContract'
            and IsActive = true
          order by LastModifiedDate ] )
        {
          BID_DESK_NOTIFICATION_EMAIL_TEMPLATE = et;
        }
      }
      return BID_DESK_NOTIFICATION_EMAIL_TEMPLATE;
    }
    set;
  }
  
  public void contractOwnerNotification(){
    Contract oldContract;
           //List<string> ToUsersEmailIds = new List<String>(); 
           List<string> ccUsersEmailIds = new List<String>(); 
           Set<Id> usrIds = new Set<Id>(); 
           Set<Id> accntIds = new Set<Id>(); 
           Set<Id> OppIds = new Set<Id>();
           List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           for(Contract newContract : newMap.values()){           
           oldContract = oldMap.get(newContract.Id);
            if((newContract.Bid_Desk_Owner__c!=null && newContract.Bid_Desk_Owner2__c==null && newContract.Bid_Desk_Owner__c!=oldContract.Bid_Desk_Owner__c) 
            || (newContract.Bid_Desk_Owner2__c!=null && newContract.Bid_Desk_Owner__c==null  && newContract.Bid_Desk_Owner2__c!=oldContract.Bid_Desk_Owner2__c) 
            ){
                 accntIds.add(newContract.AccountId);  
                 if(newContract.Opportunity__c!=null)  OppIds.add(newContract.Opportunity__c);
                 //usrIds.add(newContract.ownerId);
                 if(newContract.Bid_Desk_Owner__c!=null) usrIds.add(newContract.Bid_Desk_Owner__c);
                 if(newContract.Bid_Desk_Owner2__c!=null) usrIds.add(newContract.Bid_Desk_Owner2__c);
            }
          }
          for(OpportunityTeamMember otm:[select UserId,OpportunityId from OpportunityTeamMember where OpportunityId IN:OppIds]){
              usrIds.add(otm.UserId);
          }
          for(AccountTeamMember otm:[select UserId,AccountId from AccountTeamMember where AccountId IN:accntIds]){
              usrIds.add(otm.UserId);
          }
           Map<Id,User> cntrctUserMap = new Map<Id,User>([select id, name, Email from User where Id IN:usrIds AND isActive = true]);
                       
            for(Contract newContract : newMap.values()){                     
            if((newContract.Bid_Desk_Owner__c!=null && newContract.Bid_Desk_Owner2__c==null && newContract.Bid_Desk_Owner__c!=oldContract.Bid_Desk_Owner__c) 
            || (newContract.Bid_Desk_Owner2__c!=null && newContract.Bid_Desk_Owner__c==null  && newContract.Bid_Desk_Owner2__c!=oldContract.Bid_Desk_Owner2__c)){
                   
            // if(newContract.OwnerId!=null && cntrctUserMap!=null && cntrctUserMap.get(newContract.OwnerId)!=null){
            //  ToUsersEmailIds.add(cntrctUserMap.get(newContract.OwnerId).Email); 
            //   mail.setToAddresses(ToUsersEmailIds);
            // }
             if(newContract.OwnerId!=null && cntrctUserMap.containsKey(newContract.OwnerId)) cntrctUserMap.remove(cntrctUserMap.get(newContract.OwnerId).Id);
               for(User usr:cntrctUserMap.Values()){
                   ccUsersEmailIds.add(usr.Email);
               }
             mail.settoAddresses(ccUsersEmailIds);
             mail.setTemplateId(BID_DESK_NOTIFICATION_EMAIL_TEMPLATE.Id);
             mail.setTargetObjectId(newContract.OwnerId);
             mail.setSaveAsActivity(false);
             mail.setWhatId(newContract.Id);
            // mail.setSubject(BID_DESK_NOTIFICATION_EMAIL_TEMPLATE.Subject);
            // mail.setPlainTextBody(BID_DESK_NOTIFICATION_EMAIL_TEMPLATE.Body); 
             // Use Organization Wide Address  
               for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) {
               if(owa.Address.contains('sundeepgodishala9@gmail.com')) mail.setOrgWideEmailAddressId(owa.id); }
              }
              allMails.add(mail);
             }
        if(!allMails.isEmpty() && ccUsersEmailIds.size()>0){
        System.Debug('Size @@'+allMails.size());
        Messaging.sendEmail(allMails);
        } 
    }
}