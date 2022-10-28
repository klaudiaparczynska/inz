public abstract class TriggerHandler {
    String objectName;

    public TriggerHandler(String sObjectName) {
        objectName = sObjectName;
    }

    public virtual void beforeInsert(List<SObject> newRecords) {}
    public virtual void beforeUpdate(List<SObject> newRecords, Map<ID, SObject> newRecordMap, List<SObject> oldRecords,  Map<ID, SObject> oldRecordMap) {}
    public virtual void beforeDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap) {}
    public virtual void afterInsert(List<SObject> newRecords, Map<ID, SObject> newRecordMap) {}
    public virtual void afterUpdate(List<SObject> newRecords, Map<ID, SObject> newRecordMap, List<SObject> oldRecords,  Map<ID, SObject> oldRecordMap) {}
    public virtual void afterDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap) {}
    public virtual void afterUndelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap) {}
}