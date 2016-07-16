from tweepy import Stream
from tweepy import OAuthHandler
from tweepy.streaming import StreamListener
import time
import json

ckey = '1dABMCeAnMZ04Kkqhlm1dWRbv'
csecret = 'qZ8KYfKKon5RJIl1dIh39AKelSawifszdLECHKJF8MqgEriHK3'
atoken = '2975900626-RkzMJHqfcsbNAfozrbHRjRE0EIlSNicTjxzGQ9d'
asecret = 'CbkH8QiQ6aL5LSvEyTML3AicmVaK7rhwi6mx9Rw1EqK6Y'

class listener(StreamListener):
	def on_data(self,data):
		try:
			#print data
			tweet = json.loads(data)
			text = tweet["text"].encode('utf-8')
			location = tweet["user"]["location"].encode('utf-8')
			date = tweet["created_at"].encode('utf-8')
			#print(tweet)
			finalRecord = date+ " :: "+text+" :: "+location
			saveFile = open('cricket.csv','a')
			saveFile.write(finalRecord)
			saveFile.write('\n')
			saveFile.close()
			return True
		except BaseException,e:
			print 'failed on data',str(e)
			time.sleep(5)

	def on_error(self,status):
		print status

auth = OAuthHandler(ckey,csecret)
auth.set_access_token(atoken,asecret)
twitterStream = Stream(auth,listener()) # listener is the class defined above
twitterStream.filter(track = ["cricket"])
