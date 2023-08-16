import 'package:nexaflow_flutter_sdk/nexaflow_flutter_sdk.dart';

void main() async {
  NexaflowSdk sdk = NexaflowSdk(apiKey: 'API_KEY');

  try {
    // Get List<Website> using the getAllWebsites()
    List<Website> websites = await sdk.getAllWebsites();
    print(websites.length);

    // Get Website using the getWebsiteById()
    Website website = await sdk.getWebsiteById(websiteId: websites.first.id);
    print(website.id);

    // Get Page using the getPageById()
    Page page = await sdk.getPageById(pageId: 'ID', websiteId: 'WEBSITE_ID');
    print(page.id);

    // Submit form using the submitForm()
    String form = await sdk.submitForm(formId: 'ID', formData: {'a': 'b'});
    print(form);

    // Submit CORS request using submitCorsRequest()
    final cors = await sdk.submitCorsRequest(
        id: 'CORS_ID', method: Method.post, data: {'a': 'b'});
    print(cors);

    // Verify Email using the verifyEmail()
    final verify = await sdk.verifyEmail(id: 'EMAIL_CORS_ID', email: 'EMAIL');
    print(verify);

    // Get data using the getDataFromGoogleSheet()
    final data = await sdk.getDataFromGoogleSheet(id: 'GOOGLE_SHEET_ID');
    print(data);

    // Post data using the postDataToGoogleSheet()
    String result = await sdk.postDataToGoogleSheet(
      id: 'GOOGLE_SHEET_ID',
      data: [
        ['Serial No.', 'Value'],
        ['1', 'one'],
        ['2', 'two'],
        ['3', 'three'],
        ['4', 'four'],
      ],
    );
    print(result);
  } catch (e) {
    print(e);
  }
}
