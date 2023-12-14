The data files are fixed width text files.
The sample files contain a subset of the data in the extract files and are useful for testing your import.

For information on how to import the files into your application,
search Google for "import fixed width text file into (your application name)".

The primary foreign key constraints follow:

DOC_NUM(Profile Data)       <-        DOC_NUM(Alias Data)
DOC_NUM(Profile Data)       <-        DOC_NUM(Sentence Data)
STATUTE_CODE(Offense Codes) <-        STATUTE_CODE(Sentence Data)
SENTENCE_ID(Sentence Data)  <-        SENTENCE_ID(Consecutive Sentence Data)    
SENTENCE_ID(Sentence Data)  <-        CONSECUTIVE_TO_ID(Consecutive Sentence Data)      

Schedule A - Profile Data Layout
=======================================================
 Name                            Null?    Type
 ------------------------------- -------- ----
 DOC_NUM                         NOT NULL NUMBER(10)
 LAST_NAME                                CHAR(30)
 FIRST_NAME                               CHAR(30)
 MIDDLE_NAME                              CHAR(30)
 SUFFIX                                   CHAR(4)
 LAST_MOVE_DATE                           DATE 'YYYYMMDD' (8)
 FACILITY                                 CHAR(50)
 BIRTH_DATE                               DATE 'YYYYMMDD' (8)
 SEX                                      CHAR(1)
 RACE                                     CHAR(60)
 HAIR                                     CHAR(60)
 HEIGHT_FT                                CHAR(1)
 HEIGHT_IN                                CHAR(2)
 WEIGHT                                   CHAR(3)
 EYE                                      CHAR(60)
 STATUS                                   CHAR(10)

Schedule B - Alias Data Layout
=======================================================
 Name                            Null?    Type
 ------------------------------- -------- ----
 DOC_NUM                         NOT NULL NUMBER(10)
 LAST_NAME                                VARCHAR2(30)
 FIRST_NAME                               VARCHAR2(30)
 MIDDLE_NAME                              VARCHAR2(30)
 SUFFIX                                   VARCHAR2(4)

Schedule C - Sentence Data Layout
=======================================================
Incarcerated_Term_In_Years = 9999 indicates a death sen
tence

Incarcerated_Term_In_Years = 8888 indicates a life with
out parole sentence

Incarcerated_Term_In_Years = 7777 indicates a life sent
ence

=======================================================
 Name                            Null?    Type
 ------------------------------- -------- ----
 DOC_NUM                         NOT NULL NUMBER(10)
 SENTENCE_ID                     NOT NULL CHAR(13)
 STATUTE_CODE                    NOT NULL CHAR(30)
 SENTENCING_COUNTY                        CHAR(60)
 JS_DATE                                  DATE 'YYYYMMDD' (8)
 CRF_NUMBER                               CHAR(32)
 INCARCERATED_TERM_IN_YEARS               NUMBER(20,2)
 PROBATION_TERM_IN_YEARS                  NUMBER(20,2)

Schedule D - Offense Codes Layout
=======================================================
 Name                            Null?    Type
 ------------------------------- -------- ----
 STATUTE_CODE                    NOT NULL VARCHAR2(30)
 DESCRIPTION                     NOT NULL VARCHAR2(60)
 VIOLENT                                  VARCHAR2(1)

Schedule E - Consecutive Sentence Data Layout
=======================================================
 Name                            Null?    Type
 ------------------------------- -------- ----
 SENTENCE_ID                     NOT NULL CHAR(13)
 CONSECUTIVE_TO_ID               NOT NULL CHAR(13)

