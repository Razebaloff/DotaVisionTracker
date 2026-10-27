CREATE TABLE "User_Table" (
    "UserId_PK" SERIAL PRIMARY KEY,
    "Login" VARCHAR(50) NOT NULL UNIQUE,
    "PasswordHash" VARCHAR(255) NOT NULL,
    "Role" VARCHAR(20) NOT NULL DEFAULT 'Player',
    "StartMmr" INT NOT NULL DEFAULT 0,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT "chk_user_role" CHECK ("Role" IN ('Player', 'Manager', 'Admin'))
);

CREATE TABLE "Hero_Table" (
    "HeroId_PK" SERIAL PRIMARY KEY,
    "HeroName" VARCHAR(100) NOT NULL UNIQUE,
    "PrimaryAttribute" VARCHAR(20) NOT NULL,
    "IsActive" BOOLEAN NOT NULL DEFAULT TRUE,
    
    CONSTRAINT "chk_hero_attribute" CHECK ("PrimaryAttribute" IN ('Strength', 'Agility', 'Intelligence', 'Universal'))
);

CREATE TABLE "GameSession_Table" (
    "SessionId_PK" SERIAL PRIMARY KEY,
    "UserId_FK" INT NOT NULL,
    "SessionDate" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "Title" VARCHAR(150),
    "IsClosed" BOOLEAN NOT NULL DEFAULT FALSE,
    
    CONSTRAINT "fk_session_user" FOREIGN KEY ("UserId_FK") 
        REFERENCES "User_Table" ("UserId_PK") 
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE "Match_Table" (
    "MatchId_PK" SERIAL PRIMARY KEY,
    "SessionId_FK" INT NOT NULL,
    "HeroId_FK" INT NOT NULL,
    "CheckedByUserId_FK" INT,
    "MatchResult" VARCHAR(10) NOT NULL,
    "MmrChange" INT NOT NULL DEFAULT 0,
    "Status" VARCHAR(20) NOT NULL DEFAULT 'Draft',
    "ManagerComment" VARCHAR(500),
    "SubmittedAt" TIMESTAMP,
    "ReviewedAt" TIMESTAMP,
    
    CONSTRAINT "chk_match_result" CHECK ("MatchResult" IN ('Win', 'Lose')),
    
    CONSTRAINT "chk_match_status" CHECK ("Status" IN ('Draft', 'OnReview', 'Approved', 'Rejected')),
    
    CONSTRAINT "fk_match_session" FOREIGN KEY ("SessionId_FK") 
        REFERENCES "GameSession_Table" ("SessionId_PK") 
        ON DELETE CASCADE,
        
    CONSTRAINT "fk_match_hero" FOREIGN KEY ("HeroId_FK") 
        REFERENCES "Hero_Table" ("HeroId_PK") 
        ON DELETE RESTRICT, 
        
    CONSTRAINT "fk_match_manager" FOREIGN KEY ("CheckedByUserId_FK") 
        REFERENCES "User_Table" ("UserId_PK") 
        ON DELETE SET NULL 
);

CREATE INDEX "idx_session_user" ON "GameSession_Table"("UserId_FK");
CREATE INDEX "idx_match_session" ON "Match_Table"("SessionId_FK");
CREATE INDEX "idx_match_hero" ON "Match_Table"("HeroId_FK");
CREATE INDEX "idx_match_manager" ON "Match_Table"("CheckedByUserId_FK");
CREATE INDEX "idx_match_status" ON "Match_Table"("Status");