/**
* @author         Santosh Gudge(santosh@comitydesigns.com)
* @date           06.13.2014
* @description    Constant class contains global static variables used by the apex classes
*   			  in HeyWire for Salesforce application
*/
public class Constant {
	/*Trigger Flags to Avoid recursive running of triggers*/
     public static Boolean on_after_insert_smstext_trg = true; 
     public static Boolean on_before_insert_smstext_trg = true;
     
     public static Boolean on_after_insert_conversationheader_trg = true;
     
     
     /*Custom Object API Name without Namespace*/
      public static String sms_text_obj = 'SMS_Text__c';
      public static String conversation_header_obj = 'Conversation_Header__c';
      
      /*Exception__c object constants*/
      public static String after_insert = 'After Insert';
      public static String before_insert = 'Before Insert';
      public static String priority_high = 'High';
      
      /*Conversation_Header__c object constants*/
      public static String picklist_new = 'New';
      public static String stage_active = 'Active';
      
      /*LiveText Status Constant*/
       public static String status_avaialble = 'Avaialble';
       public static String status_offline = 'Offline';
       public static String status_away = 'Away';
      
}