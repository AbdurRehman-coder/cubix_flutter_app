import 'package:cubix_app/features/explore/models/course_model.dart';

class MockCourseData {
  static const Map<CourseCategory, List<Course>> courses = {
    CourseCategory.core: [
      Course(
        id: '1',
        title: 'English & Composition',
        code: 'ENG 101',
        icon: '🧠',
        category: 'Core',
        description:
            'In this course, you\'ll learn fundamental writing and communication skills through comprehensive grammar, composition, and literary analysis.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Writing Fundamentals',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Grammar Basics',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Sentence Structure',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Paragraph Development',
                status: LessonStatus.locked,
              ),
            ],
          ),
          Chapter(
            id: 'ch2',
            title: 'Chapter 2: Essay Writing',
            lessons: [
              Lesson(
                id: 'l4',
                title: 'Introduction Techniques',
                status: LessonStatus.locked,
              ),
              Lesson(
                id: 'l5',
                title: 'Body Paragraphs',
                status: LessonStatus.locked,
              ),
              Lesson(
                id: 'l6',
                title: 'Conclusion Strategies',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '2',
        title: 'Microeconomics',
        code: 'ECON 101',
        icon: '🧠',
        category: 'Core',
        description:
            'In this course, you\'ll learn how people and markets make decisions about limited resources through core concepts.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Introduction to Economics',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Scarcity And Choice',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Opportunity Cost',
                status: LessonStatus.locked,
              ),
              Lesson(
                id: 'l3',
                title: 'The Economic Problem',
                status: LessonStatus.locked,
              ),
            ],
          ),
          Chapter(
            id: 'ch2',
            title: 'Chapter 2: Supply and Demand Basics',
            lessons: [
              Lesson(
                id: 'l4',
                title: 'The Law Of Demand',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l5',
                title: 'The Law Of Supply',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l6',
                title: 'Market Equilibrium',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '3',
        title: 'Computer Science Basics',
        code: 'CS 101',
        icon: '🧠',
        category: 'Core',
        description:
            'In this course, you\'ll learn fundamental programming concepts and computational thinking through hands-on coding exercises.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Programming Fundamentals',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Variables and Data Types',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Control Structures',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Functions and Methods',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '4',
        title: 'Physics Principles',
        code: 'PHY 101',
        icon: '🧠',
        category: 'Core',
        description:
            'In this course, you\'ll learn fundamental physics concepts including mechanics, energy, and motion through practical applications.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Classical Mechanics',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Newton\'s Laws',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Force and Motion',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Energy Conservation',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '5',
        title: 'Chemistry Essentials',
        code: 'CHEM 101',
        icon: '🧠',
        category: 'Core',
        description:
            'In this course, you\'ll learn basic chemistry principles including atomic structure, chemical bonding, and reactions.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Atomic Structure',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Elements and Atoms',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Electron Configuration',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Periodic Table',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '6',
        title: 'Biology Fundamentals',
        code: 'BIO 101',
        icon: '🧠',
        category: 'Core',
        description:
            'In this course, you\'ll learn essential biology concepts including cell structure, genetics, and evolution.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Cell Biology',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Cell Structure',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Cell Division',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Cellular Respiration',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
    ],
    CourseCategory.business: [
      Course(
        id: '7',
        title: 'Business Administration',
        code: 'BUS 101',
        icon: '💼',
        category: 'Business',
        description:
            'In this course, you\'ll learn fundamental business principles including management, organization, and strategic planning.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Business Fundamentals',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Business Models',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Organizational Structure',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Strategic Planning',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '8',
        title: 'Marketing Strategy',
        code: 'MKT 201',
        icon: '💼',
        category: 'Business',
        description:
            'In this course, you\'ll learn marketing fundamentals including consumer behavior, market research, and campaign development.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Marketing Basics',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Market Research',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Consumer Behavior',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Brand Strategy',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '9',
        title: 'Financial Management',
        code: 'FIN 301',
        icon: '💼',
        category: 'Business',
        description:
            'In this course, you\'ll learn financial principles including budgeting, investment analysis, and risk management.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Financial Basics',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Financial Statements',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Budget Planning',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Investment Analysis',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '10',
        title: 'Operations Management',
        code: 'OPS 201',
        icon: '💼',
        category: 'Business',
        description:
            'In this course, you\'ll learn operations fundamentals including process optimization, quality control, and supply chain management.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Operations Basics',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Process Design',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Quality Management',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Supply Chain',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '11',
        title: 'Human Resources',
        code: 'HR 101',
        icon: '💼',
        category: 'Business',
        description:
            'In this course, you\'ll learn HR fundamentals including recruitment, employee development, and organizational behavior.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: HR Fundamentals',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Recruitment Process',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Employee Training',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Performance Management',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '12',
        title: 'Entrepreneurship',
        code: 'ENT 301',
        icon: '💼',
        category: 'Business',
        description:
            'In this course, you\'ll learn entrepreneurship fundamentals including startup development, business planning, and innovation.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Startup Basics',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Business Ideas',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Market Validation',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Business Plan',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
    ],
    CourseCategory.mind: [
      Course(
        id: '13',
        title: 'Psychology Basics',
        code: 'PSY 101',
        icon: '🧘',
        category: 'Mind',
        description:
            'In this course, you\'ll learn fundamental psychology concepts including cognitive processes, behavior, and mental health.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Introduction to Psychology',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'What is Psychology?',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Research Methods',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Ethical Considerations',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '14',
        title: 'Mindfulness & Meditation',
        code: 'MED 101',
        icon: '🧘',
        category: 'Mind',
        description:
            'In this course, you\'ll learn mindfulness techniques including meditation practices, stress reduction, and emotional regulation.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Mindfulness Basics',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'What is Mindfulness?',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Breathing Techniques',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Body Awareness',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '15',
        title: 'Cognitive Science',
        code: 'COG 201',
        icon: '🧘',
        category: 'Mind',
        description:
            'In this course, you\'ll learn cognitive science fundamentals including memory, learning, and decision-making processes.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Cognitive Processes',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Memory Systems',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Learning Theory',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Decision Making',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '16',
        title: 'Mental Health Awareness',
        code: 'MH 101',
        icon: '🧘',
        category: 'Mind',
        description:
            'In this course, you\'ll learn mental health fundamentals including common disorders, coping strategies, and wellness practices.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Mental Health Basics',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Understanding Mental Health',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Common Disorders',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Coping Strategies',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '17',
        title: 'Stress Management',
        code: 'SM 101',
        icon: '🧘',
        category: 'Mind',
        description:
            'In this course, you\'ll learn stress management techniques including identification, reduction, and prevention strategies.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Understanding Stress',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'What is Stress?',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Stress Triggers',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Stress Response',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '18',
        title: 'Positive Psychology',
        code: 'PPY 201',
        icon: '🧘',
        category: 'Mind',
        description:
            'In this course, you\'ll learn positive psychology principles including happiness, resilience, and well-being enhancement.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Happiness Science',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'What is Happiness?',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Gratitude Practice',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Building Resilience',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
    ],
    CourseCategory.humanities: [
      Course(
        id: '19',
        title: 'World History',
        code: 'HIST 101',
        icon: '📚',
        category: 'Humanities',
        description:
            'In this course, you\'ll learn world history fundamentals including major civilizations, events, and cultural developments.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Ancient Civilizations',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Mesopotamia',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Ancient Egypt',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Ancient Greece',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '20',
        title: 'Philosophy & Ethics',
        code: 'PHIL 101',
        icon: '📚',
        category: 'Humanities',
        description:
            'In this course, you\'ll learn philosophical fundamentals including ethics, logic, and major philosophical traditions.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Introduction to Philosophy',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'What is Philosophy?',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Logic and Reasoning',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Ethical Theories',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '21',
        title: 'Literature Studies',
        code: 'LIT 201',
        icon: '📚',
        category: 'Humanities',
        description:
            'In this course, you\'ll learn literature analysis including literary devices, genres, and critical reading skills.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Literary Analysis',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Reading Techniques',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Literary Devices',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Genre Analysis',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '22',
        title: 'Cultural Anthropology',
        code: 'ANTH 101',
        icon: '📚',
        category: 'Humanities',
        description:
            'In this course, you\'ll learn anthropology fundamentals including culture, society, and human behavior across different contexts.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Understanding Culture',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'What is Culture?',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Cultural Practices',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Social Structure',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '23',
        title: 'Art & Design History',
        code: 'ART 101',
        icon: '📚',
        category: 'Humanities',
        description:
            'In this course, you\'ll learn art history fundamentals including major movements, artists, and design principles.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: Art Through Ages',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Ancient Art',
                status: LessonStatus.completed,
              ),
              Lesson(
                id: 'l2',
                title: 'Renaissance Art',
                status: LessonStatus.current,
              ),
              Lesson(
                id: 'l3',
                title: 'Modern Art',
                status: LessonStatus.locked,
              ),
            ],
          ),
        ],
      ),
      Course(
        id: '24',
        title: 'Religious Studies',
        code: 'REL 101',
        icon: '📚',
        category: 'Humanities',
        description:
            'In this course, you\'ll learn about major world religions including their beliefs, practices, and historical development.',
        chapters: [
          Chapter(
            id: 'ch1',
            title: 'Chapter 1: World Religions',
            lessons: [
              Lesson(
                id: 'l1',
                title: 'Christianity',
                status: LessonStatus.completed,
              ),
              Lesson(id: 'l2', title: 'Islam', status: LessonStatus.current),
              Lesson(id: 'l3', title: 'Buddhism', status: LessonStatus.locked),
            ],
          ),
        ],
      ),
    ],
  };

  static List<Course> getAllCourses() {
    return courses.values.expand((courseList) => courseList).toList();
  }
}
