The data files are fixed width text files.
The sample files contain a subset of the data in the extract files and are useful for testing your import.

For information on how to import the files into your application,
search Google for "import fixed width text file into (your application name)".

The primary foreign key constraints follow:

DOC_NUM(Profile Data)       <-        DOC_NUM(Alias Data)
DOC_NUM(Profile Data)       <-        DOC_NUM(Sentence Data)
STATUTE_CODE(Offense Codes) <-        STATUTE_CODE(Sentence Data)

Schedule A - Profile Data Layout
=======================================================
 Name                            Null?    Type
 ------------------------------- -------- ----
 DOC_NUM                         NOT NULL NUMBER(10)
 LAST_NAME                                VARCHAR2(30)
 FIRST_NAME                               VARCHAR2(30)
 MIDDLE_NAME                              VARCHAR2(30)
 SUFFIX                                   VARCHAR2(5)
 LAST_MOVE_DATE                           DATE 'YYYYMMDD' (8)
 FACILITY                                 VARCHAR2(40)
 BIRTH_DATE                               DATE 'YYYYMMDD' (8)
 SEX                                      VARCHAR2(1)
 RACE                                     VARCHAR2(40)
 HAIR                                     VARCHAR2(40)
 HEIGHT_FT                                VARCHAR2(2)
 HEIGHT_IN                                VARCHAR2(2)
 WEIGHT                                   VARCHAR2(4)
 EYE                                      VARCHAR2(40)
 STATUS                                   VARCHAR2(10)

Schedule B - Alias Data Layout
=======================================================
 Name                            Null?    Type
 ------------------------------- -------- ----
 DOC_NUM                         NOT NULL NUMBER(10)
 LAST_NAME                                VARCHAR2(30)
 FIRST_NAME                               VARCHAR2(30)
 MIDDLE_NAME                              VARCHAR2(30)
 SUFFIX                                   VARCHAR2(5)

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
 SENTENCE_ID                     NOT NULL VARCHAR2(20)
 CONSEC_TO_SENTENCE_ID                    VARCHAR2(20)
 STATUTE_CODE                    NOT NULL VARCHAR2(40)
 SENTENCING_COUNTY                        VARCHAR2(40)
 JS_DATE                                  DATE 'YYYYMMDD' (8)
 CRF_NUMBER                               VARCHAR2(40)
 INCARCERATED_TERM_IN_YEARS               NUMBER(10,2)
 PROBATION_TERM_IN_YEARS                  NUMBER(10,2)

Schedule D - Offense Codes Layout
=======================================================
 Name                            Null?    Type
 ------------------------------- -------- ----
 STATUTE_CODE                    NOT NULL VARCHAR2(38)
 DESCRIPTION                     NOT NULL VARCHAR2(40)
 VIOLENT                                  VARCHAR2(1)

