import 'package:flutter/material.dart';

import '../../data/app_data.dart';

class OpportunitiesPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const OpportunitiesPage({
    super.key,
    required this.user,
  });

  @override
  State<OpportunitiesPage> createState() =>
      _OpportunitiesPageState();
}


class _OpportunitiesPageState
    extends State<OpportunitiesPage> {

  String searchText = '';


  @override
  Widget build(BuildContext context) {

    final filteredOpportunities =
        opportunities.where((opportunity) {

      final title =
          opportunity['title']
              .toString()
              .toLowerCase();

      final company =
          opportunity['company']
              .toString()
              .toLowerCase();

      final search =
          searchText.toLowerCase();

      return title.contains(search) ||
          company.contains(search);

    }).toList();


    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Opportunities',
        ),
      ),


      body: Column(
        children: [

          // SEARCH
          Padding(
            padding:
                const EdgeInsets.all(16),

            child: TextField(

              decoration:
                  const InputDecoration(
                labelText:
                    'Search jobs or internships',

                prefixIcon:
                    Icon(Icons.search),

                border:
                    OutlineInputBorder(),
              ),

              onChanged: (value) {

                setState(() {
                  searchText = value;
                });

              },
            ),
          ),


          // OPPORTUNITY LIST
          Expanded(
            child:
                filteredOpportunities.isEmpty

                    ? const Center(
                        child: Text(
                          'No opportunities found.',
                        ),
                      )

                    : ListView.builder(

                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                        ),

                        itemCount:
                            filteredOpportunities
                                .length,

                        itemBuilder:
                            (context, index) {

                          final opportunity =
                              filteredOpportunities[
                                  index];

                          return opportunityCard(
                            context,
                            opportunity,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }


  // ------------------------------------
  // OPPORTUNITY CARD
  // ------------------------------------

  Widget opportunityCard(
    BuildContext context,
    Map<String, dynamic> opportunity,
  ) {

    return Card(

      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      child: ListTile(

        contentPadding:
            const EdgeInsets.all(12),


        leading:
            const CircleAvatar(
          child: Icon(
            Icons.business_center,
          ),
        ),


        title: Text(
          opportunity['title'],

          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),


        subtitle:
            Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const SizedBox(
              height: 6,
            ),

            Text(
              opportunity['company'],
            ),

            Text(
              '📍 ${opportunity['location']}',
            ),

            const SizedBox(
              height: 5,
            ),

            Text(
              'Skills: '
              '${opportunity['skills'].join(', ')}',
            ),

            const SizedBox(
              height: 5,
            ),

            Text(
              opportunity['compensation'],
            ),
          ],
        ),


        trailing:
            const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),


        onTap: () {

          showOpportunityDetails(
            context,
            opportunity,
          );

        },
      ),
    );
  }


  // ------------------------------------
  // DETAILS
  // ------------------------------------

  void showOpportunityDetails(
    BuildContext context,
    Map<String, dynamic> opportunity,
  ) {

    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      builder: (context) {

        return SafeArea(

          child:
              SingleChildScrollView(

            padding:
                const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  opportunity['title'],

                  style:
                      const TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  opportunity['company'],

                  style:
                      const TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Text(
                  opportunity[
                      'description'],
                ),

                const SizedBox(
                  height: 15,
                ),

                detailRow(
                  'Type',
                  opportunity['type'],
                ),

                detailRow(
                  'Location',
                  opportunity['location'],
                ),

                detailRow(
                  'Qualification',
                  opportunity[
                      'qualification'],
                ),

                detailRow(
                  'Compensation',
                  opportunity[
                      'compensation'],
                ),

                detailRow(
                  'Domain',
                  opportunity[
                      'domain'],
                ),

                const SizedBox(
                  height: 15,
                ),

                const Text(
                  'Required Skills',

                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,

                  children:
                      opportunity[
                              'skills']
                          .map<Widget>(
                    (skill) {

                      return Chip(
                        label:
                            Text(skill),
                      );
                    },
                  ).toList(),
                ),

                const SizedBox(
                  height: 25,
                ),

                SizedBox(
                  width:
                      double.infinity,

                  height: 50,

                  child:
                      ElevatedButton.icon(

                    icon:
                        const Icon(
                      Icons.send,
                    ),

                    label:
                        const Text(
                      'Apply Now',
                    ),

                    onPressed: () {

                      Navigator.pop(
                        context,
                      );

                      ScaffoldMessenger
                          .of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Application submitted successfully!',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget detailRow(
    String title,
    String value,
  ) {

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 8,
      ),

      child: Row(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          SizedBox(
            width: 120,

            child: Text(
              '$title:',
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
            ),
          ),
        ],
      ),
    );
  }
}