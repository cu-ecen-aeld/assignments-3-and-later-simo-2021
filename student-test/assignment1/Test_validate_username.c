#include "unity.h"
#include <stdbool.h>
#include <stdlib.h>
#include "../../examples/autotest-validate/autotest-validate.h"
#include "../../assignment-autotest/test/assignment1/username-from-conf-file.h"

/**
* This function should:
*   1) Call the my_username() function in autotest-validate.c to get your hard coded username.
*   2) Obtain the value returned from function malloc_username_from_conf_file() in 
username-from-conf-file.h within
*       the assignment autotest submodule at assignment-autotest/test/assignment1/
*   3) Use unity assertion TEST_ASSERT_EQUAL_STRING_MESSAGE to verify the two strings are equal.  See
*       the [unity assertion reference](https://github.com/ThrowTheSwitch/Unity/blob/master/docs/UnityAssertionsReference.md)
*/


void test_validate_my_username()
{
    // 1. Appeler la fonction my_username()
    const char *username_from_code = my_username();

    // 2. Appeler la fonction qui lit /conf/username.txt
    char *username_from_file = malloc_username_from_conf_file();

    // 3. Vérifier que les deux chaînes sont égales
    TEST_ASSERT_EQUAL_STRING_MESSAGE(username_from_code,
                                     username_from_file,
                                     "username.txt mismatch with my_username()");

    // 4. Libérer la mémoire allouée par malloc_username_from_conf_file()
    free(username_from_file);
}
