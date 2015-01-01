public with sharing class ConversationHeaderTriggerHandler extends TriggerManager.TriggerHandler  {
	
	  public override void onAfterInsert(List < sObject > newRecords, Map < ID, SObject > newRecordsMap) {
	    if (Constant.on_after_insert_conversationheader_trg == true) { 
	        Constant.on_after_insert_conversationheader_trg = false;
	        afterInsertUpdate((Map < Id, Conversation_Header__c > ) newRecordsMap, null);
	    }
	}
	
	/**
     * @description  
     * @param 
     * @return void 
     */  
    private void afterInsertUpdate(Map < Id, Conversation_Header__c > newConversationHeaderMap, Map < Id, Conversation_Header__c > oldConversationHeaderMap) {
        try {
		     Boolean triggerExecutionEnabled = false;
		     HeyWireGlobalSettings__c gblSettings = Util.getHeyWireGlobalSettings();
		     if (gblSettings != null) {
		         if (gblSettings.GlobalTriggerExecutionEnabled__c != null) {
		             triggerExecutionEnabled = gblSettings.GlobalTriggerExecutionEnabled__c;
		         }
		     }
		     if (triggerExecutionEnabled) {
		         List < SMS_Text__c > newSmstextList = new List < SMS_Text__c > ();
		         List < SMS_Text__c > smstextList = [SELECT Support_Number__c, Originating_Number__c, Id, Conversation_Header__c FROM SMS_Text__c limit 2000];
		         if (!smstextList.isEmpty()) {
		             for (Conversation_Header__c c: newConversationHeaderMap.values()) {
		                 for (SMS_Text__c sms: smstextList) {
		                     if (!(c.Originating_Number__c != sms.Originating_Number__c) &&
		                         !(c.Support_Number__c != sms.Support_Number__c)) {
		                         sms.Conversation_Header__c = c.Id;
		                         newSmstextList.add(sms);
		                     }
		                 }
		             }
		         }
		         if (!newSmstextList.isEmpty()) {
		             AccessController.updateAsUser(newSmstextList);
		         }
		     }
		
		 } catch (exception e) {
		     Util.insertException(Constant.sms_text_obj + Constant.after_insert, Constant.priority_high, e.getMessage());
		 }
 }
}