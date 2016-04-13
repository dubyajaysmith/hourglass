global with sharing class AccountRemoter {

    public Id accountId { get; set; }
    public static Account account { get; set; }
    public AccountRemoter() { } // empty constructor
    
    @RemoteAction
    global static Account getAccount(Id accountId) {
        account = [
            SELECT Id, Name, Phone, Type, NumberOfEmployees 
            FROM Account 
            WHERE Id = :accountId
        ];
        return account;
    }
}