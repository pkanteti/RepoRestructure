/*
* 
* @author        Santosh Gudge(santosh@comitydesigns.com)
* @date          06.13.2014
* @description   Util class contains utility methods used by the apex classes
*   			 in Agent One for Salesforce application
*
*/
public with sharing class Util {
   /***
    * @description Retrieve default enable application values from custom settings
    * @Param  none
    * @Return HeyWireGlobalSettings__c records
    ***/ 
    public static HeyWireGlobalSettings__c getHeyWireGlobalSettings() {
    	// Retrieve default enable application values from custom settings
        HeyWireGlobalSettings__c hwgsUser = HeyWireGlobalSettings__c.getInstance(UserInfo.getUserId());
        HeyWireGlobalSettings__c hwgsGlobal = HeyWireGlobalSettings__c.getOrgDefaults();
        System.debug('hwgsUser - '+hwgsUser);
        System.debug('hwgsGlobal - '+hwgsGlobal);
        if (hwgsUser != null) {
            return hwgsUser;
        }
        else if (hwgsGlobal != null){
            return hwgsGlobal;
        }
        else {
            return null;
        }
    }
    
    /**
     *  @description Returns a field map for a given sobject type. 
     *  @param objectId
     *  @param priority
     *  @param error description
     */
    public static void insertException(String objectId, String priority, String errorDescription) {
    	String namespacePrefix = Util.getNamespaceForPackage();
    	Exception__c exObject = new Exception__c();
		exObject.AssociatedUser__c = UserInfo.getUserId();
		exObject.ErrorDescription__c = errorDescription;
		exObject.ObjectId__c = objectId;
		exObject.Priority__c = priority;
			
		insert exObject;		
    }
    
    /**
     *  @description Returns the namespace for the package 
     *  @returns String namespace
     */
    public static String getNamespaceForPackage(){
    	String nameSpacePrefix = '';
    	ApexClass cs =[select NamespacePrefix from ApexClass where Name =:'TriggerManager'];
		if(cs.NamespacePrefix != null && cs.NamespacePrefix.length() > 0){
			nameSpacePrefix = cs.NamespacePrefix + '__';
		}
		return nameSpacePrefix;
    }
}