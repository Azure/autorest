// ./superagent-mock-config.js file
module.exports = [
  {
    /**
     * regular expression of URL
     */
    pattern: 'https://domain.example(.*)',

    /**
     * returns the data
     *
     * @param match array Result of the resolution of the regular expression
     * @param params object sent by 'send' function
     * @param headers object set by 'set' function
     */
    fixtures: function (match, params, headers) {
      /**
       * Returning error codes example:
       *   request.get('https://domain.example/404').end(function(err, res){
       *     console.log(err); // 404
       *     console.log(res.notFound); // true
       *   })
       */
      if (match[1] === '/pet/1') {
        return JSON.stringify({
          id:1,
          name:"http://petstore.swagger.io/v2/swagger.json",
          photoUrls:[],
          tags:[],
          status:"available"
        });
      }
    },
    callback: function (match, data) {
      return {
        text: data,
        statusCode: 200
      };
    }
  }
];
