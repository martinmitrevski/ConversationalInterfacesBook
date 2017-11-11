# -*- coding: utf-8 -*-

import os
import numpy as np
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import confusion_matrix
from sklearn.svm import LinearSVC
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import StratifiedKFold
from coremltools.converters import sklearn
from sklearn.feature_extraction import DictVectorizer
from sklearn.model_selection import train_test_split

def make_Corpus(root_dir):
    polarity_dirs = [os.path.join(root_dir,f) for f in os.listdir(root_dir)]    
    corpus = []    
  
    for polarity_dir in polarity_dirs:
        sentiment = 'bad' if polarity_dir == 'txt_sentoken/neg' else 'good'
        reviews = [os.path.join(polarity_dir,f) for f in os.listdir(polarity_dir)]
        for review in reviews:
            reviewInfo = [sentiment]
            doc_string = "";
            with open(review) as rev:
                for line in rev:
                    doc_string = doc_string + line
            reviewInfo.append(doc_string)
            if not corpus:
                corpus = [reviewInfo]
            else:
                corpus.append(reviewInfo)
    return corpus

root_dir = 'txt_sentoken'
corpus = make_Corpus(root_dir)
corpus = np.array(corpus)
X = corpus[:, 1]
y = corpus[:, 0]
      
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.15, random_state=22)

vectorizer = TfidfVectorizer()
vectorized = vectorizer.fit_transform(X)
words = open('words_ordered.txt', 'w')
for feature in vectorizer.get_feature_names():
    words.write(feature.encode('utf-8') + '\n')
words.close()
model = LinearSVC()
model.fit(vectorized, y)
coreml_model = sklearn.convert(model)
coreml_model.save('MovieReviews.mlmodel')