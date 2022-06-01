pragma solidity ^0.8.0;


//SPDX-License-Identifier: Unlicense


contract Tweet {

    uint tweet_id_len = 10 ** 16;

    struct tweet_type{
        uint tweet_id;
        string tweet_text;
    }

    tweet_type[] private tweets;

    function _createTweets(string memory _tweet_text) private {
        uint tweet_id = getTweetId(_tweet_text);
        uint len = tweet_length();
        tweets[len] = tweet_type(tweet_id, _tweet_text);
    }

    function tweet_length() private view returns (uint) {
        uint x = tweets.length;
        return x;
    }

    function getTweetId(string memory _tweet_text) private view returns (uint) {

        //Generate id using keccak256 function
        uint id = uint(keccak256(abi.encodePacked(_tweet_text)));
        return id % tweet_id_len;
    }

    function _readTweets() private view returns(string[] memory) {
        string[] memory just_tweets;

        //loop through tweets array. copy the tweets into just_tweets array and return just_tweets
        for(uint i = 0; i < tweet_length(); i++) {
            just_tweets[i] = tweets[i].tweet_text;
        }

        return just_tweets;
    }

    function _update_tweet(string memory _old_tweet, string memory _new_tweet) private returns (bool) {

        //Generate old_tweet_id
        uint old_tweet_id = getTweetId(_old_tweet);

        uint i = 0;
        uint flag = 0;

        //Loop through tweet array, check if tweet_id matches with old_tweet_id. If matched, update
        for(i = 0; i < tweet_length(); i++) {
            if (tweets[i].tweet_id == old_tweet_id) {
                tweets[i].tweet_text = _new_tweet;
                flag = 1;
                break;
            }
        }

        //if update fails return false, else generate new_tweet_id, update tweet_id and return true
        if (flag == 0) {
            return false;
        }
        else {
            uint new_tweet_id =  getTweetId(_new_tweet);
            tweets[i].tweet_id = new_tweet_id;
            return true;
        }
    }

    function _delete_tweet(string memory _tweet_text) private returns (bool){

        //Generate tweet_id of _tweet_text
        uint tweet_id = getTweetId(_tweet_text);

        uint flag = 0;
        uint i = 0;
        uint j = 0;

        //Loop through tweet array, check tweet_id with tweet_id of tweets array. if found delete.
        for(i = 0; i < tweet_length(); i++) {
            if (tweets[i].tweet_id == tweet_id) {
                delete tweets[i];
                flag = 1;
                break;
            }
        }

        //If delete fails, return false. Else, remove the gap created by delete operation
        if(flag == 0) {
            return false;
        }
        else {
            if (i < tweet_length() - 1) {
                for (j = i; j < (tweet_length() - 1); j++) {
                    tweets[j] = tweets[j+1];
                }
                delete tweets[tweet_length() - 1];
            }
            return true;
        }
    }
}
