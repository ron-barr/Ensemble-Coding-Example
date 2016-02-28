Summary

This is an experimental code designed to explore an alternative approach to model ensembling.
Normally when we run an ensemble model we run two or more models, and then combine the models together
in some fashion.

The models do not communicate with each other.  In other words the models are independent, and are combined
at the end of the analysis.

This approach is to take the results of the first model.  Calculate the error of each prediction.
Then build a second model to predict the error, with a new variable added to the model, namely the prediction
from the first model.

The final prediction is then based on the combination of the prediction from the first model combined with
the error predcition of the second model.



Details:

The model was used as an entry in the Prudential Kaggle competition. The competition scores were used to
evalute the effectiveness of the model (which is one way to ensure that the result is honest!).
The ensemble model did show a modest improvement in the accuracy of the prediction, (though sadly not enough
to move me very far up the leader board).  I have no error or accuracy calcuations as part of this code set. This is really just
to illustrate the concept.

More details:
Model tuning was handled offline.  The only feature engineering employed was to make the variables into numerics as
I used XGBOOST, and to replace any NA with median values