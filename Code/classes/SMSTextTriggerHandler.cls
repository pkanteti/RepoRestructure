public with sharing class SMSTextTriggerHandler extends TriggerManager.TriggerHandler {
   	/* Business Rules:
        		  - When a new record (SMS_Text__c) is created, 
        		    verify if there is an active conversation header with the combination of Originating Number + Support Number.
  				  - If no match found, 
  				    then create a new Conversation Header record and associate with the newly created header record with the SMS text record.
                  - If a match is found, then just link the conversation header with the SMS record.
                  
                  Solution Approach:
                  1. create before insert trigger on SMS_Text__c object, to check if:
                      - Originating_Number__c and Support_Number__c fields of SMS_Text__c matches with any
                      	Originating_Number__c and Support_Number__c fields of Conversation_Header__c object records.
                      	if (yes) {
                      		Associate Conversation_Header__c.Id to 
                      		SMS_Text__c.Conversation_Header__c (lookup relationship).
                      	} 
                 2. create after insert trigger on SMS_Text__c.
                     - . Check if SMS_Text__c.Conversation_Header__c ==null, if null we need to create Conversation_Header__c record.
                     - . Create Conversation_Header__c Where :
                            Conversation_Header__c.Originating_Number__c = SMS_Text__c.Originating_Number__c;
                            Conversation_Header__c.Support_Number__c = SMS_Text__c.Support_Number__c;
                 3. create after insert trigger on Conversation_Header__c.
                    -- check if :
                     - Originating_Number__c and Support_Number__c fields of Conversation_Header__c matches with any
                      	Originating_Number__c and Support_Number__c fields of SMS_Text__c object records. 
                      	if (yes) {
                      		Associate Conversation_Header__c.Id to 
                      		SMS_Text__c.Conversation_Header__c (lookup relationship).
                      		and update SMS_Text__c.
                      	} 
        	*/
   public override void onAfterInsert(List < sObject > newRecords, Map < ID, SObject > newRecordsMap) {
	    if (Constant.on_after_insert_smstext_trg == true) {
	        Constant.on_after_insert_smstext_trg = false;
	        afterInsertUpdate((Map < Id, SMS_Text__c > ) newRecordsMap, null);
	    }
	}

	public override void onBeforeInsert(List < sObject > newRecords) {
	    if (Constant.on_before_insert_smstext_trg == true) {
	        Constant.on_before_insert_smstext_trg = false;
	        beforeInsert((List < SMS_Text__c > ) newRecords);
	    }
	}
	
	/**
     * @description  
     * @param 
     * @return void 
     */  
    private void beforeInsert(List < SMS_Text__c > newSmsTexList) {
        try {
            Boolean triggerExecutionEnabled = false;
            HeyWireGlobalSettings__c gblSettings = Util.getHeyWireGlobalSettings();
            if (gblSettings != null) {
                if (gblSettings.GlobalTriggerExecutionEnabled__c != null) {
                    triggerExecutionEnabled = gblSettings.GlobalTriggerExecutionEnabled__c;
                }
            }
            if (triggerExecutionEnabled) {
                if (!newSmsTexList.isEmpty()) {
                    List < Conversation_Header__c > ConversationHeaderList = [SELECT Support_Number__c, Originating_Number__c, Id
                        FROM Conversation_Header__c limit 2000
                    ];
                    if (!ConversationHeaderList.isEmpty()) {
                        for (SMS_Text__c s: newSmsTexList) {
                            for (Conversation_Header__c c: ConversationHeaderList) {
                                if (!(s.Originating_Number__c != c.Originating_Number__c) &&
                                    !(s.Support_Number__c != c.Support_Number__c)) {
                                    s.Conversation_Header__c = c.Id;
                                }
                            }
                        }
                    }
                }
            }
        } catch (exception e) {
            Util.insertException(Constant.sms_text_obj + Constant.before_insert, Constant.priority_high, e.getMessage());
        }
    }
	/**
     * @description  
     * @param 
     * @return void 
     */  
    private void afterInsertUpdate(Map < Id, SMS_Text__c > newSmsTextMap, Map < Id, SMS_Text__c > oldSmsTextMap) {
        try {
            Boolean triggerExecutionEnabled = false;
            HeyWireGlobalSettings__c gblSettings = Util.getHeyWireGlobalSettings();
            if (gblSettings != null) {
                if (gblSettings.GlobalTriggerExecutionEnabled__c != null) {
                    triggerExecutionEnabled = gblSettings.GlobalTriggerExecutionEnabled__c;
                }
            }
            if (triggerExecutionEnabled) {
                List < Conversation_Header__c > ConversationHeaderList = new List < Conversation_Header__c > ();
                for (SMS_Text__c sms: newSmsTextMap.values()) {
                    Conversation_Header__c convObj = new Conversation_Header__c();
                    if (!(sms.Conversation_Header__c != null)) {
                        convObj.Originating_Number__c = sms.Originating_Number__c;
                        convObj.Support_Number__c = sms.Support_Number__c;
                        convObj.Stage__c = Constant.picklist_new;
                        ConversationHeaderList.add(convObj);
                    }
                }
                if (!ConversationHeaderList.isEmpty()) {
                    AccessController.insertAsUser(ConversationHeaderList);
                }
            }
        } catch (exception e) {
            Util.insertException(Constant.conversation_header_obj + Constant.after_insert, Constant.priority_high, e.getMessage());
        }
    }
}