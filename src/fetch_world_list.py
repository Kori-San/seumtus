
import os
from wiktionaryparse import WiktionaryParser

# get real path of script
path = os.path.dirname(os.path.realpath(__file__))

# download input file here : https://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-articles.xml.bz2
# then unzip it: bzip2 -dk enwiktionary-latest-pages-articles.xml.bz2 ( make sure to unzip in real path of script )
input_file = path + "/enwiktionary-latest-pages-articles.xml"

# don't touch pls
output_file = path + "/word_list.json"


def example():
    # create object
    parser = WiktionaryParser(input_file, output_file)
    # this specify the maximum number of words/pages to parse
    parser.setMaxPageCount(10000)
    # set which languages to save
    parser.setTargetLanguages('French')
    # set which sections to save
    parser.setTargetSections('Adjective', 'Adverb', 'Verb', 'Noun')
    # sets additionnal settings to avoid fetching useless words
    parser.setTrackPlurals(False)
    parser.setTrackDerived(False)
    parser.setTrackDefinitions(False)
    parser.setWordsOnly(True)
    # parse
    parser.parse()

    # After fetching all words do:
    # ---------------------------
    # 1 - sed -i 'y/āáǎàēéěèīíǐìōóǒòūúǔùǖǘǚǜĀÁǍÀĒÉĚÈĪÍǏÌŌÓǑÒŪÚǓÙǕǗǙǛ/aaaaeeeeiiiioooouuuuüüüüAAAAEEEEIIIIOOOOUUUUÜÜÜÜ/' word_list.json
    #     To Avoid Accents
    # ---------------------------
    # 2 - Delete matching ([a-zA-Z ]{0,4})
    #     To Avoid words with lenghts <= 4
    # ---------------------------
    # 3 - Delete matching ([a-zA-Z ]{9,1000})
    #     To Avoid words with lenghts >= 9
    # ---------------------------
    # 4 - Delete matching ([a-zA-Z ]*-[a-zA-Z ]*)
    #     To Avoid words with '-'
    # ---------------------------
    # 4.5 - sed -i -e '/^$/d' word_list.json
    # ---------------------------
    # 5 - cp word_list.json ../data/word_list
    # ---------------------------


example()
