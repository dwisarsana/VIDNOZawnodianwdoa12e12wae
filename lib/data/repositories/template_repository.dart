import '../../domain/models/template_item.dart';
import '../mocks/mock_template_data.dart';

class TemplateRepository {
  // Simulate network delay
  Future<List<TemplateItem>> getTemplates() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockTemplateData.templates;
  }
}
