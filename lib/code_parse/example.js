async function getPageAndParse() {
    try{
        let url = 'https://api.nexaflow.xyz/api/page/PAGE_ID';
        url += '?websiteId=WEBSITE_ID';
        const response  = await fetch(url, {
            method: 'GET',
            headers: {
                'x-api-key': 'API_KEY',
            }       
        })
        const responseJSON = await response.json();
        let result = {};
        responseJSON.blocks.map((block) => {
          if(block.nested){
            return;
          }
          if (Array.isArray(block.blockData)) {
            let arr = block.blockData.map((nestedObj) => {
                return Object.values(nestedObj).reduce(
                    (acc, obj) => {
                      let blockData = obj.blockData;
                        if(typeof blockData === 'string'){ 
                          let nested = responseJSON
                                        .blocks
                                        .find((block) => block.id === blockData);
                            let blockName = obj.fieldName;
                            if(Array.isArray(nested.blockData)){
                              nested = nested.blockData.map((nestedObj) => {
                                  return Object.values(nestedObj).reduce(
                                      (acc, { blockData }) => {
                                          return { ...acc, ...blockData };
                                      },
                                      {}
                                  );
                              });
                              blockData = {[blockName] : nested};
                            }
                            if(typeof nested.blockData === 'object'){
                              nested = Object.values(nested.blockData).reduce(
                                (acc, { blockData }) => {
                                  return { ...acc, ...blockData };
                                }, {});
                              blockData = {[blockName] : nested};
                            }
                        }
                        return { ...acc, ...blockData };
                    }, 
                    {}
                );
            });
            result[block.blockName] = arr ;
            return;
          }
          if( block.blockType === 'group'){
              result[block.blockName] = Object.values(block.blockData).reduce(
                (acc, { blockData }) => {
                  return { ...acc, ...blockData };
                }, {});
              return;
          }
          
          result[block.blockName] = block.blockData[block.blockName];
      });
        return result;
    }catch(e){
        console.log(e);
    }
}

getPageAndParse().then((cms_parsed_data) => {
      //this variable contains whole page data;
      const cms_page_test = cms_parsed_data;
      //this variables contains each block data;

      const cms_test = cms_parsed_data['test'];


      /** your code goes here **/
      console.log(cms_parsed_data);

  }).catch((e) => {
      console.log(e);
  });
  
