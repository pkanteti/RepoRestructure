/**
* @author         Santosh Gudge(santosh@comitydesigns.com)
* @data           06.19.2014
* @description    ConsoleIntegrationController class contains methods used by the ConsoleIntegrationCasePage
*                 in LiveText for Salesforce application.
*/
public with sharing class ConversationHeaderController { 
	
   private final Conversation_Header__c conversationHeader;
    /*Integer used to show user the total Live Text Records*/
   public integer total_size { get; set; }
   
   public String conversationHeaderId {
        get;
        set;
    }
    public String strCurrentConversationHeader {
        get {
        	return JSON.serialize(conversationHeaderList);
        }
        set;
    }
     /*list to hold current ConversationHeader*/
    public List <Conversation_Header__c> conversationHeaderList {
        get;
        set;
    }
   public String[] getstatus() {
       return status;
   }

   public void setstatus(String[] status) {
       this.status = status;
   }
   
   String[] status = new String[] {};

   public ConversationHeaderController(ApexPages.StandardController stdController) {
        this.conversationHeader = (Conversation_Header__c)stdController.getRecord();
        getConversationHeaderList();
    }
    
    /*Retrive values from custom settings ??*/
   /**
    * @description: SelectOption for Livetext status
    * @param   
    * @return status options.
    */
   public List < SelectOption > getItems() {
       List < SelectOption > options = new List < SelectOption > ();
       options.add(new SelectOption(constant.status_avaialble, constant.status_avaialble));
       options.add(new SelectOption(constant.status_offline, constant.status_offline));
       options.add(new SelectOption(constant.status_away, constant.status_away));
       return options;
   }
   
    /**
    * @description: gets list of Conversation Header
    * @param   
    * @return  List of Conversation Header
    */
    public List<Conversation_Header__c> getConversationHeaderList(){
    	this.conversationHeaderList = [SELECT Support_Number__c, Stage__c, Originating_Number__c, Name, Id, 
    										  Conversation_Unique_Identifier__c FROM Conversation_Header__c 
    								   WHERE Stage__c=:Constant.picklist_new];
    	return conversationHeaderList;
    }
    
   /**
    * @description: assigns conversationHeader records to strCurrentConversationHeader
    * @param   
    * @return  List of Conversation Header
    */
    public PageReference  getConversationHeaderRecords(){
    	List<Conversation_Header__c> chList = getConversationHeaderList();
    	this.strCurrentConversationHeader = JSON.serialize(conversationHeaderList);
    	return null;
    }
    
    /**
    * @description: pagereference for accept button. stage is made active by dml call.
    * @param   
    * @return  null
    */
     public PageReference  Accept(){
     	if (conversationHeaderId !=null && conversationHeaderId.length() != 0) {
     		List<Conversation_Header__c> chList = [SELECT Support_Number__c, Stage__c, Originating_Number__c, Name, Id, 
    										  			  Conversation_Unique_Identifier__c FROM Conversation_Header__c 
    								   						WHERE Id=:conversationHeaderId];
    		if (!chList.isEmpty()) {
    			List<Conversation_Header__c> chUpdateList = new List<Conversation_Header__c>();
    			for (Conversation_Header__c c:chList) {
    				c.Stage__c = constant.stage_active;
    				chUpdateList.add(c);
    			}
    			AccessController.updateAsUser(chUpdateList);
    		}
        	System.debug('KKKKKKK::'+ this.conversationHeaderId);
     	}
        return null;
    }
}