public with sharing class WarehouseCalloutService implements Queueable {
    @future(callout=true)
    public static void doCallout(){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment?_ga=2.135587057.1304456528.1645340070-134278837.1637329731');
        request.setMethod('GET');
        HttpResponse httpresponse = http.send(request);

        List<Product2> productstobeUpdated = new List<Product2>();

        if(httpresponse.getStatusCode()==200){
            List<Object> results = (List<Object>) JSON.deserializeUntyped(httpresponse.getBody());
            for(Object obj:results){
                Map<String,Object> object_individual = (Map<String,Object>)obj;
                Product2 new_product = new Product2();
                new_product.Replacement_Part__c = (Boolean)object_individual.get('replacement');
                new_product.Cost__c	 = (Decimal)object_individual.get('cost');
                new_product.Current_Inventory__c = (Decimal)object_individual.get('quantity');
                new_product.Lifespan_Months__c = (Decimal)object_individual.get('lifespan');
                new_product.Maintenance_Cycle__c = (Decimal)object_individual.get('maintenanceperiod');
                new_product.Warehouse_SKU__c = (String)object_individual.get('sku');
                new_product.Name = (String) object_individual.get('name');
                productstobeUpdated.add(new_product);
            }
        }
        if(productstobeUpdated.size()>0){
            upsert productstobeUpdated;
            System.debug('Done Syncing');
        }
    }
    public static void execute(QueueableContext context){
        doCallout();
    }
}

