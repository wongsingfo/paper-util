#!/usr/bin/env python3

import argparse
import sys

try:
    from scholarly import scholarly
    from fuzzy_match import algorithims
    import bibtexparser
    import regex
except ImportError as e:
    print("""Install dependencies first using the following command and try again:

    pip install scholarly fuzzy_match bibtexparser regex
""")
    raise e


class NotFoundError(Exception):
    def __init__(self, message):
        self.message = message


def query_yes_no(question, default="yes"):
    """Ask a yes/no question via raw_input() and return their answer.

    "question" is a string that is presented to the user.
    "default" is the presumed answer if the user just hits <Enter>.
        It must be "yes" (the default), "no" or None (meaning
        an answer is required of the user).

    The "answer" return value is True for "yes" or False for "no".
    """
    valid = {"yes": True, "y": True, "ye": True,
             "no": False, "n": False}
    if default is None:
        prompt = " [y/n] "
    elif default == "yes":
        prompt = " [Y/n] "
    elif default == "no":
        prompt = " [y/N] "
    else:
        raise ValueError("invalid default answer: '%s'" % default)

    while True:
        sys.stdout.write(question + prompt)
        choice = input().lower()
        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            sys.stdout.write("Please respond with 'yes' or 'no' "
                             "(or 'y' or 'n').\n")


def query_bib_title(bibtex: dict) -> bool:
    return query_yes_no(bibtex["title"])


def get_bibtex_for_pubs(pubs: str) -> str:
    """Returns bibtex"""
    search_query = scholarly.search_pubs(pubs)
    for result in search_query:
        if query_bib_title(result["bib"]):
            return scholarly.bibtex(result)

    raise NotFoundError(f"Can't find {pubs}")

def search_pubs_in_bib(bib: str, pubs:str) -> str:
    """Returns matched bibtex ID"""
    with open(bib) as bibtex_file:
        bib_database = bibtexparser.load(bibtex_file)

    def match_algo(title, key) -> float:
        if regex.search('(%s){e<=1}' % key, title, flags=regex.IGNORECASE):
            return 0.8
        return algorithims.trigram(title, key)


    match_threshold = 0.7
    results : List[Tuple[float, dict]] = []

    for entry in bib_database.entries:
        if 'title' in entry:
            score = match_algo(entry['title'], pubs)
            match_result = (score, entry)
            results.append(match_result)

    results.sort(key=lambda x: x[0], reverse=True)
    for result in results:
        if result[0] >= match_threshold and query_bib_title(result[1]):
            return result[1]['ID']

    raise NotFoundError(f"no match for '{pubs} in {bib}")


def prepend_to_bib(new_entry: str, bibfile: str):
    with open(bibfile) as bibtex_file:
        bib_database = bibtexparser.load(bibtex_file)

    new_database = bibtexparser.loads(new_entry)
    bib_database.entries.insert(0, new_database.entries[0])

    with open(bibfile, 'w') as bibtex_file:
        bibtexparser.dump(bib_database, bibtex_file)


if __name__ == "__main__":
    example_text = """Examples:
    ./google_scholar.py 'ZygOS: Achieving Low Tail Latency for Microsecond-scale Networked Tasks'
    ./google_scholar.py 'Snap: a Microkernel Approach to Host Network' -f ref.bib
"""
    parser = argparse.ArgumentParser(description="Get bibtex for publication",
            epilog=example_text,
            formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('pubs', help="publication title")
    parser.add_argument('-f', metavar='bibtex', help="look up this bibtex before searching Google Scholar")
    args = parser.parse_args()

    if args.f is not None:
        try: 
            print(f"Searching the {args.f} file")
            bibtex_id = search_pubs_in_bib(args.f, args.pubs)
            print(bibtex_id)
            exit(0)
        except NotFoundError:
            print(f"Cannot find '{args.pubs}' in {args.f}")

    print("Searching on Google Scholar")
    bibtex = get_bibtex_for_pubs(args.pubs)

    print()
    print(bibtex)

    if args.f and query_yes_no(f"Add this entry to {args.f}?"):
        prepend_to_bib(bibtex, args.f)





