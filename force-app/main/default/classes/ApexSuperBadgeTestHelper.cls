public with sharing class ApexSuperBadgeTestHelper {
    private static final string STATUS_NEW = 'New';
    private static final string WORKING = 'Working';
    private static final string CLOSED = 'Closed';
    private static final string REPAIR = 'Repair';
    private static final string REQUEST_ORIGIN = 'Web';
    private static final string REQUEST_TYPE = 'Routine Maintenance';
    private static final string REQUEST_SUBJECT = 'Testing subject';
    public static Vehicle__c createVehicle(){
        return new Vehicle__c(name='Lighting');
    }
    public static Product2 createProduct(){
        return new Product2(name = 'SuperEquipment',lifespan_months__C = 10,maintenance_cycle__C = 10,replacement_part__c = true);
    }
    public static Case createMaintenanceRequest(id vehicleId,id equipmentId){
        return new Case(Type=REPAIR,Status=STATUS_NEW,Origin=REQUEST_ORIGIN,Subject=REQUEST_SUBJECT,Equipment__c = equipmentId,Vehicle__c=vehicleId);
    }
    public static Equipment_Maintenance_Item__c createWorkPart(id equipmentId,id requestId){
        Equipment_Maintenance_Item__c wp = new Equipment_Maintenance_Item__c(Equipment__c = equipmentId,
        Maintenance_Request__c = requestId);
        return wp;
    }

}
