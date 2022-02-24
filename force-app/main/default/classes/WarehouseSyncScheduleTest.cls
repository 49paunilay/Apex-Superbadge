@isTest
public with sharing class WarehouseSyncScheduleTest {
    
    // implement scheduled code here
    @isTest 
    public static void testScheduleMethod(){
        String scheduleTime = '00 00 01 * * ?';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Id jobId = System.schedule('ScheduledApexTest', scheduleTime, new WarehouseSyncSchedule());
        List<Task> lt = [SELECT Id
                                FROM Task
                                WHERE Id= :jobId];
        System.assertEquals(0, lt.size(), 'Tasks exist before job has run');
        Test.stopTest();
        lt = [SELECT Id
                    FROM Task
            WHERE Id = :jobId];
    }
}