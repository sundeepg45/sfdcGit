trigger ChatterApprovals on Deal_Risk__c (after insert, after update) {
    
    List<FeedItem> fditmList = new List<FeedItem>();
    for(Deal_Risk__c dr:trigger.new){
        if(dr.Contract_Type__c=='consulting'){
            Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
            submitRequest.setObjectId(dr.id);
            Approval.ProcessResult result = Approval.process(submitRequest);
            
            String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
            string msg='Approval process initiated for the record, '+salesforceHost+'/'+dr.id;
            FeedItem item = new FeedItem(ParentId=dr.id, Body=msg);
            fditmList.add(item);
        }
    }
    if(fditmList.size()>0){ insert fditmList;}
}