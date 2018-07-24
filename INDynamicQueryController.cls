public with sharing class INDynamicQueryController {
    
    public string value{get;set;}
    public string fields{get;set;}
    public list<FieldDetails> details{get;set;}
    public List<sObject> lstObjs {get;set;}
    public List<string> lstFlds {get;private set;}
    
    public INDynamicQueryController(){
        details=new list<FieldDetails>();
    }
    
    public List<SelectOption> getObjectList(){
        List<SelectOption> ObjectList=new List<SelectOption>();
        list<Schema.SObjectType> lstObjectList=Schema.getGlobalDescribe().values();
        ObjectList.add(new SelectOption('-1','Select Object'));
        for(Schema.SObjectType objDetails:lstObjectList){
           SelectOption selOption=new SelectOption(objDetails.getDescribe().getname(),objDetails.getDescribe().getlabel());
           ObjectList.add(selOption);
        }
        return ObjectList; 
    }
    
    public void FieldList(){
        details=new list<FieldDetails>();
        if(string.isNotBlank(value)){
            system.debug('value'+value);
            Schema.SObjectType sobjectype =Schema.getGlobalDescribe().get(value);
            Schema.DescribeSObjectResult result=sobjectype.getDescribe();
            List<Schema.SObjectField> fieldList=result.fields.getMap().values();
            for(Schema.SObjectField fieldDetails:fieldList){
                string fieldname='string';
                FieldDetails fddetails=new FieldDetails();
                fddetails.fieldApiname=fieldDetails.getDescribe().getname();
                fddetails.fieldname=fieldDetails.getDescribe().getlabel();
                schema.displaytype fieldType=fieldDetails.getDescribe().gettype();
            
                if(fieldType == Schema.DisplayType.Currency ||
                   fieldType == Schema.DisplayType.Double)
                    fieldname= 'Decimal';
                if(fieldType == Schema.DisplayType.Integer)
                    fieldname= 'Integer';
                if(fieldType == Schema.DisplayType.Boolean)
                    fieldname= 'Boolean';
                if(fieldType == Schema.DisplayType.DateTime)
                    fieldname= 'DateTime';    
                if(fieldType == Schema.DisplayType.Date)
                    fieldname= 'Date';            
                if(fieldType == Schema.DisplayType.Time)
                    fieldname= 'Time';
                if(fieldType == Schema.DisplayType.Picklist)
                    fieldname= 'Picklist';    
                
               fddetails.fieldtype=fieldname;
               details.add(fddetails); 
          
            }
        }
    }
    public void GetData(){
        lstFlds = new List<String>();
        string query='select '+fields+ ' from '+value;
        system.debug(query);
        lstObjs=Database.query(query);
        Set<string> setFlds = new Set<String>();
        for(integer i=0;i<lstObjs.size();i++){
            setFlds.addAll(lstObjs[i].getPopulatedFieldsAsMap().keySet());
        }
        lstFlds.addAll(setFlds);
        system.debug(setFlds);
    }
    
    class FieldDetails
    {
        public string fieldname{get;set;}
        public string fieldApiname{get;set;}
        public string fieldtype{get;set;}
    }
}