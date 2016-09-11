trigger OpportunityHistoryTracker on Opportunity (after update) {

    final List<Schema.FieldSetMember> trackedFields = 
        SObjectType.Opportunity.FieldSets.HistoryTracking.getFields();

    if (trackedFields.isEmpty()) return;

    final List<OpportunityHistoryTracking__c> fieldChanges = 
        new List<OpportunityHistoryTracking__c>();

    if(!trigger.isUpdate)
        return;

    for (Opportunity newOpportunity : trigger.new) {

        final Opportunity oldOpportunity = trigger.oldmap.get(newOpportunity.Id);

        for (Schema.FieldSetMember fsm : trackedFields) {

            String fieldName  = fsm.getFieldPath();
            String fieldLabel = fsm.getLabel();

            if (newOpportunity.get(fieldName) == oldOpportunity.get(fieldName))
                continue;

            String oldValue = String.valueOf(oldOpportunity.get(fieldName));
            String newValue = String.valueOf(newOpportunity.get(fieldName));

            if (oldValue != null && oldValue.length()>255) 
                oldValue = oldValue.substring(0,255);

            if (newValue != null && newValue.length()>255) 
                newValue = newValue.substring(0,255); 

            final OpportunityHistoryTracking__c opportunityHistory = 
                new OpportunityHistoryTracking__c();

            //opportunityHistory.name         = fieldLabel;
            opportunityHistory.apiName__c   = fieldName;
            //opportunityHistory.User__c      = newOpportunity.Id;
            opportunityHistory.ChangedBy__c = UserInfo.getUserName();
            opportunityHistory.Opportunity__c = newOpportunity.Id;
            opportunityHistory.OldValue__c  = oldValue;
            opportunityHistory.NewValue__c  = newValue;

            fieldChanges.add(opportunityHistory);
        }
    }

    if (!fieldChanges.isEmpty()) {
        insert fieldChanges;
    }
}