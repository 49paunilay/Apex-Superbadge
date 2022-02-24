public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> workOrder,Map<Id,Case> nonWorkOrder) {
        Set<Id> validIds = new Set<Id>();
        for(Case c : workOrder){
            if(c.Status=='Closed' && nonWorkOrder.get(c.Id).Status!='Closed'){
                if(c.Type=='Repair' || c.Type=='Routine Maintenance'){
                    validIds.add(c.Id);
                }
            }
        }
        if(!validIds.isEmpty()){
            List<Case> newCases = new List<Case>();
            List<Case> closedcasesList = [SELECT Id, 
                                                Vehicle__c, 
                                                Equipment__c, 
                                                Equipment__r.Maintenance_Cycle__c,
                                                (SELECT Id,Equipment__c,Quantity__c FROM Equipment_Maintenance_Items__r) 
                                        FROM Case WHERE Id IN : validIds];

            Map<Id,Case> closedCases = new Map<Id,Case>(closedcasesList);
            Map<Id,Decimal> MaintenanceCycle = new Map<Id,Decimal>();
            AggregateResult[] results = [SELECT Maintenance_Request__c, 
                                                    MIN(Equipment__r.Maintenance_Cycle__c)cycle 
                                                FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c IN : validIds GROUP BY Maintenance_Request__c];

            for(AggregateResult ar:results){
                MaintenanceCycle.put((Id)ar.get('Maintenance_Request__c'), (Decimal)ar.get('cycle'));
            }
            for(Case c : closedCases.values()){
                Case nc = new Case(ParentId = c.Id,Status='New',Subject='Routine Maintenance',Type='Routine Maintenance',Vehicle__c = c.Vehicle__c,Equipment__c=c.Equipment__c,Origin='Web',Date_Reported__c = Date.today());
                if(MaintenanceCycle.containsKey(c.Id)){
                    nc.Date_Due__c = Date.today().addDays((Integer)MaintenanceCycle.get(c.Id));  
                }else{
                    nc.Date_Due__c = Date.today().addDays((Integer)c.Equipment__r.Maintenance_Cycle__c);  
                }
                newCases.add(nc);
            }
            insert newCases;
            List<Equipment_Maintenance_Item__c> newEquipmentMaintenanceItems = new List<Equipment_Maintenance_Item__c>();
            for(Case c:newCases){
                for(Equipment_Maintenance_Item__c emi : closedCases.get(c.ParentId).Equipment_Maintenance_Items__r){
                    Equipment_Maintenance_Item__c clonedemi = emi.clone();
                    clonedemi.Maintenance_Request__c = c.Id;
                    newEquipmentMaintenanceItems.add(clonedemi);
                }
            }
            insert newEquipmentMaintenanceItems;
        }

    }
}