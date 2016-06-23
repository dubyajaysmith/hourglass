@isTest
public class TimerControllerTest {
    
    @testSetup 
    static void setupTestData() {
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
        User portalAccountOwner1 = new User(
            //UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'i@jamiesmiths.com',
            Alias = 'batman',
            Email='i@jamiesmiths.com',
            EmailEncodingKey='UTF-8',
            Firstname='jamie',
            Lastname='smith',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        
        Database.insert(portalAccountOwner1);
        
        //Create account
        system.runas(portalAccountOwner1){
            
            User pwner = new User();
            
            pwner = [SELECT Id, ProfileId, email FROM user WHERE Alias = 'batman' ];
            
            Account portalAccount1 = new Account(
            	Name = 'Test',
            	OwnerId = pwner.Id
            );
            Database.insert(portalAccount1);
                	
            //Create contact
            Contact contact1 = new Contact(
               	FirstName = 'jamie',
                Lastname = 'smith',
                AccountId = portalAccount1.Id,
                Email = 'i@jamiesmiths.com'
            );
            Database.insert(contact1);
            
            //Create attachment
            Attachment attachment = new Attachment();
            
            attachment.Name = 'Unit Test Attachment';
            Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
            attachment.body = bodyBlob;
            //attachment.parentId = incident.id;
            
            //Database.insert(attachment);
            
            Project__c proj = new project__c();
            proj.Name__c = 'Master';
            proj.Time_in_Seconds__c = 42;
            Database.insert(proj);
            
        }
        
    }
    
    static testMethod void TimerControllerTest() {
        
        User user1 = new User();
        user1 = [SELECT Id, ProfileId, email FROM user WHERE Alias = 'batman' ];
        
        /*Contact cont1 = new Contact();
        cont1 = [SELECT AccountId, FirstName, LastName, MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingCountryCode, Name
            FROM Contact WHERE FirstName = 'Testie' LIMIT 1 ];*/
            
        Account acc1 = new Account();
        acc1 = [SELECT Id, Name
            FROM Account LIMIT 1 ];
            
        Contact contact = new Contact();
        contact = [SELECT Id, Name, FirstName, Lastname, AccountId, Email
        FROM Contact WHERE LastName = 'smith' LIMIT 1 ];
        
        /*Attachment attachment = new Attachment();
        attachment = [
            SELECT Id, OwnerId, Name, CreatedDate, ParentId, body, Description, ContentType 
            FROM Attachment 
            LIMIT 1
        ];*/
        
        Project__c proj = new project__c();
        proj = [
            SELECT id, name, name__c, Time_in_Seconds__c, Time__c, Day_of_Week__c
            FROM Project__c
            Limit 1
        ];
        
        List<Project__c> projs = new List<project__c>();
        projs = [
            SELECT id, name, name__c, Time_in_Seconds__c, Time__c, Day_of_Week__c
            FROM Project__c
            Limit 1
        ];
        
        System.RunAs(user1){
            
            TimerController controller = new TimerController();
            
            controller.masterProject = proj;
            controller.projects = projs;
            controller.projectsLastWeek = projs;
            controller.project = proj;
            controller.pros = 'Beach';
            controller.getProjectsLastWeek();
        }
        
        System.RunAs(user1){
            TimerController.pushTime(42, 'Beach');
            TimerController.pushName('Beach');
            TimerController.delName('Beach, Border, Collie, Gene');
        }
        
        System.RunAs(user1){
            TimerController controller = new TimerController();
            controller.projects = null;
            TimerController.pushName('Beach');
        }
    }
    
}