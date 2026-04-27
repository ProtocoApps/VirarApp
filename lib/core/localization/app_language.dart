enum AppLanguage {
  portuguese('pt', 'PT'),
  english('en', 'EN'),
  spanish('es', 'ES'),
  libras('libras', 'Libras');

  const AppLanguage(this.code, this.label);

  final String code;
  final String label;
}
