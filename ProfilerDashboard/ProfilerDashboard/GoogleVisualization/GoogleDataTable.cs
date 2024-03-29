﻿/*
   Copyright 2009-2010 Gary Bortosky

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

namespace Bortosky.Google.Visualization
{
    using System.Collections.Generic;
    using System.Data;
    using System.IO;

    using Bortosky.Google.Visualization.Columns;

    public class GoogleDataTable
    {
        #region Constants and Fields

        private readonly DataTable subjectTable;

        private List<GoogleDataColumn> columns;

        private StreamWriter writer;

        #endregion

        #region Constructors and Destructors

        /// 
        /// <param name="table">The table to serialize</param>
        public GoogleDataTable(DataTable table)
        {
            subjectTable = table;
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Columns of DateTime Type can be specified as one of the various Google date
        /// types for specialized serialization. The implementation makes use of the
        /// ExtendedProperties of the column, namely the "GoogleDateType" key.
        /// </summary>
        /// <param name="column">The DataColumn of DateTime Type whose Google Data Type is
        /// to be specified.</param>
        /// <param name="dateType">The Google Date Type of the passed column</param>
        public static void SetGoogleDateType(DataColumn column, GoogleDateType dateType)
        {
            column.ExtendedProperties.Add("GoogleDateType", dateType);
        }

        /// <summary>
        /// Returns a string representation of the GoogleDataTable's JSON object
        /// </summary>
        public string GetJson()
        {
            string str;

            using (var mem = new MemoryStream())
            {
                WriteJson(mem);
                mem.Position = 0;
                using (var sr = new StreamReader(mem))
                {
                    str = sr.ReadToEnd();
                    sr.Close();
                }
            }

            return str;
        }

        /// 
        /// <param name="columnName">The DataColumn of DateTime Type whose Google Data Type
        /// is to be specified.</param>
        /// <param name="dateType">The Google Date Type of the passed column</param>
        public void SetGoogleDateType(string columnName, GoogleDateType dateType)
        {
            SetGoogleDateType(subjectTable.Columns[columnName], dateType);
        }

        /// 
        /// <param name="stream">The stream to which to serialize the subject
        /// DataTable</param>
        public void WriteJson(Stream stream)
        {
            int colCount = 0, rowCount = 0;
            writer = new StreamWriter(stream);
            columns = new List<GoogleDataColumn>();

            foreach (DataColumn c in subjectTable.Columns)
            {
                columns.Add(GoogleDataColumn.CreateGoogleDataColumn(c));
            }

            writer.Write("{\"cols\": [");

            foreach (GoogleDataColumn gc in columns)
            {
                writer.Write("{0}{1}", colCount++ == 0 ? "" : ", ", gc.SerializedColumnIdentifier);
            }

            writer.Write("], \"rows\": [");

            foreach (DataRow r in subjectTable.Rows)
            {
                writer.Write("{0}{{\"c\": [", rowCount++ == 0 ? "" : ", ");
                colCount = 0;
                foreach (GoogleDataColumn gc in columns)
                {
                    writer.Write("{0}{{\"v\": {1}}}", colCount++ == 0 ? "" : ", ", gc.SerializedValue(r));
                }
                writer.Write("]}");
            }

            writer.Write("]}");
            writer.Flush();
        }

        #endregion
    }
}