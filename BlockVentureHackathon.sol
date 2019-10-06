pragma solidity ^0.5.1;

contract registration{
    event details(string name, uint phone, string dob, string email, studentStatus status);
    event studentSummary(string name, string dob, studentStatus status);
    
    
    enum studentStatus {
        verified,
        started,
        finished
    }

    struct student{
        string name;
        uint sid;
        uint phone;
        string dob;
        string email;
        string password;
        bool registered;
        studentStatus status;
    }
        
    student[] public students;
        
    function create_student(string memory name, uint sid, uint phone,string memory dob, string memory email, string memory password, bool registered, studentStatus status) public {
        uint id = students.push(student(name, sid, phone, dob, email, password, registered, status)) - 1;
        emit details(name, phone, dob, email, status);
    }

    modifier onlyIfPaid(uint id) {
        require(students[id].registered == true, "Not paid");
        _;
    }
    
    function verifyPayment(uint id) public payable onlyIfPaid(id) {
        students[id].status = studentStatus.verified;
    }

    
    function studentLogin(uint sid, string memory password) public {
        
        for(uint i = 0; i < students.length; i++){
            
            if (students[i].sid == sid && string(students[i].password) == string(password)){
                
                students[i].status = studentStatus.started;
                emit studentSummary(students[i].name, students[i].dob, students[i].status);
            }
                
        }
    }
    
}

contract adminportal{
    
    enum ExamStatus{
        Start,
        End,
        Results
    }
    
    event ExamSummary( string label, uint startTime, uint endTime, ExamStatus status );
    
    struct exam{
        string label;
        uint startTime;
        uint endTime;
        ExamStatus status;
    }
    
    exam test;
    
    function admin(string memory label, uint startTime, uint endTime ) public {
        
        if (now<startTime){
            test.status = ExamStatus.Start;
        }
        
        if (now>=startTime && now<=endTime){
            test.status = ExamStatus.End;
        }
        
        if (now>endTime){
            test.status = ExamStatus.Results;
        }
        
        emit ExamSummary(test.label, test.startTime, test.endTime, test.status);
    }

}