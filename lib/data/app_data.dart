const roles = [
  'Student',
  'Industry',
  'Academician',
  'Institution',
];


// -------------------------
// STUDENT SUBJECTS
// -------------------------

const studentSubjects = [
  'Computer Science',
  'Information Technology',
  'Artificial Intelligence & ML',
  'Data Science',
  'Cyber Security',
  'Software Development',
  'Web Development',
  'Mobile App Development',
  'Cloud Computing',
  'Other',
];


// -------------------------
// ACADEMICIAN SUBJECTS
// -------------------------

const academicianSubjects = [
  'Computer Science',
  'Information Technology',
  'Artificial Intelligence & ML',
  'Data Science',
  'Cyber Security',
  'Software Engineering',
  'Cloud Computing',
  'Research & Innovation',
  'Ayurveda / Healthcare Technology',
  'Other',
];


// -------------------------
// INDUSTRY DOMAINS
// -------------------------

const industryDomains = [
  'IT & Software',
  'Artificial Intelligence & ML',
  'Data Science',
  'FinTech',
  'Healthcare',
  'EdTech',
  'Cyber Security',
  'Cloud & DevOps',
  'Digital Marketing',
  'Research & Development',
  'Other',
];


// -------------------------
// OPPORTUNITIES
// -------------------------

final List<Map<String, dynamic>> opportunities = [
  {
    'id': '1',
    'title': 'Flutter Developer Intern',
    'company': 'TechNova Solutions',
    'type': 'Internship',
    'location': 'Ahmedabad',
    'skills': [
      'Flutter',
      'Dart',
      'SQL',
    ],
    'qualification': 'BCA / MCA / B.Tech',
    'compensation': '₹12,000/month',
    'description':
        'Build mobile applications and work with a software development team.',
    'domain': 'IT & Software',
  },

  {
    'id': '2',
    'title': 'Data Analyst Intern',
    'company': 'DataBridge India',
    'type': 'Internship',
    'location': 'Remote',
    'skills': [
      'Python',
      'SQL',
      'Data Analysis',
    ],
    'qualification': 'BCA / MCA / B.Sc IT',
    'compensation': '₹10,000/month',
    'description':
        'Analyze business data and prepare dashboards and reports.',
    'domain': 'Data Science',
  },

  {
    'id': '3',
    'title': 'Java Developer',
    'company': 'CodeCraft Pvt Ltd',
    'type': 'Job',
    'location': 'Gandhinagar',
    'skills': [
      'Java',
      'SQL',
      'Problem Solving',
    ],
    'qualification': 'MCA / B.Tech / M.Tech',
    'compensation': '₹4.5 LPA',
    'description':
        'Entry-level Java development role with mentoring and training.',
    'domain': 'IT & Software',
  },

  {
    'id': '4',
    'title': 'AI/ML Research Intern',
    'company': 'AI Research Lab',
    'type': 'Research',
    'location': 'Bengaluru',
    'skills': [
      'Python',
      'AI/ML',
      'Problem Solving',
    ],
    'qualification': 'MCA / M.Tech / MSc',
    'compensation': '₹20,000/month',
    'description':
        'Work on applied AI research projects with industry mentors.',
    'domain': 'Artificial Intelligence & ML',
  },
];