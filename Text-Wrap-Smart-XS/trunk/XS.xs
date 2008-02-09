#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

MODULE = Text::Wrap::Smart::XS                PACKAGE = Text::Wrap::Smart::XS

void
xs_exact_wrap(text, wrap_at)
        char *text;
        unsigned int wrap_at;
    PROTOTYPE: $$
    INIT:
        char *str;
        char *str_iter;
        char *text_iter;
        unsigned int i;
        unsigned long average;
        unsigned long c;
        unsigned long length;
        unsigned long offset;
        long length_iter;
    PPCODE:
        length = strlen(text);
        text_iter = &text[0];

        length_iter = length;
        i = 0;
        do {
            length_iter -= wrap_at;
            i++;
        } while (length_iter > 0);
        average = (int) ceil((float) length / (float) i);

        for (offset = 0; offset < length; offset += average) {
            Newx(str, average + 1, char);

            c = average;
            str_iter = str;
            while (c-- > 0 && *text_iter) {
                *str_iter++ = *text_iter++;
            }
            *str_iter = '\0';

            EXTEND(SP, 1);
            PUSHs(sv_2mortal(newSVpv(str,0)));

            Safefree(str);
        }

void
xs_fuzzy_wrap(text, wrap_at)
        char *text;
        unsigned int wrap_at;
    PROTOTYPE: $$
    INIT:
        char *p;
        char *str;
        char *str_iter;
        char *text_iter;
        unsigned int i;
        unsigned long average;
        unsigned long count;
        unsigned long diff;
        unsigned long length;
        unsigned long offset;
        long average_iter;
        long length_iter;
    PPCODE:
        length = strlen(text);
        text_iter = &text[0];

        length_iter = length;
        i = 0;
        do {
            length_iter -= wrap_at;
            i++;
        } while (length_iter > 0);
        average = (int) ceil((float) length / (float) i);

        offset = 0;
        while (offset < length) {
            average_iter = average;
            count = 0;
            str_iter = text_iter;

            while (*str_iter) {
                p = strchr(str_iter, ' ');
                if (p == NULL)
                    diff = 0;
                else
                    diff = p - str_iter;
                if (diff > average_iter)
                    break;
                if (average_iter < 0)
                    break;
                average_iter--;
                count++;
                str_iter++;
            }

            Newx(str, count + 1, char);

            str_iter = str;
            i = count;
            if (i == 0)
                break;
            while (i--) {
               if (i == 0 && *text_iter == ' ')
                   break;
               *str_iter++ = *text_iter++;
            }
            text_iter++;
            *str_iter = '\0';

            EXTEND(SP, 1);
            PUSHs(sv_2mortal(newSVpv(str,0)));

            Safefree(str);

            offset += count;
        }