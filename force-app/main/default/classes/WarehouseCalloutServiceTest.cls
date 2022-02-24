@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    @Istest 
    public static void testgetRequest(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        Id jobId = System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();
        List<AsyncApexJob> jobs = new List<AsyncApexJob>();
        jobs = [SELECT Id, Status FROM AsyncApexJob where Id =:jobId];
        System.assertEquals(1, jobs.size());
        
    }

}